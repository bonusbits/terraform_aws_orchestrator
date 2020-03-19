def load_yaml_vars(workspace = ENV.fetch('TF_WORKSPACE', 'example_vpc_dev_usw2'))
  # puts 'DEBUG: LOADING YAML VARIABLES'
  require 'yaml'
  yaml_file = workspace[0...-5]
  @project_vars = @project_vars.merge(YAML.load_file(File.join(__dir__, '../vars/rake/shared.yml')))
  @project_vars = @project_vars.merge(YAML.load_file(File.join(__dir__, "../vars/rake/#{yaml_file.downcase}.yml")))
  tf_roles = @project_vars['tf_roles']
  color_added = Array.new
  tf_roles.each do |role|
    # puts "DEBUG: CHECKING (#{role})"
    color_added << if role.match?('COLOR')
                     # puts "DEBUG: FOUND COLOR in (#{role})"
                     role.sub!('COLOR', @project_vars['deploy_color'])
                   else
                     role
                   end
  end
  @project_vars['tf_roles'] = color_added

  env_var_file = @project_vars['tf_env_var_file']
  @project_vars['tf_env_var_file'] = env_var_file.sub!('COLOR', @project_vars['deploy_color'])
end

# Defaults to Environment Vars, but can be overridden
def fetch_env_vars(
  workspace = ENV.fetch('TF_WORKSPACE', 'demo-dev-usw2').downcase,
  region = ENV.fetch('AWS_DEFAULT_REGION', 'us-west-2').downcase,
  deploy_color = ENV.fetch('DEPLOY_COLOR', 'blue').downcase,
  profile = ENV.fetch('AWS_PROFILE', 'dev').downcase
)
  raise 'ERROR: DEPLOY_COLOR must be blue or green only' unless deploy_color.match?('blue') || deploy_color.match?('green')

  @project_vars = Hash.new
  @project_vars['tf_workspace'] = workspace
  @project_vars['aws_region'] = region
  @project_vars['aws_profile'] = profile
  @project_vars['deploy_color'] = deploy_color
end

def header
  # require 'colorize'
  return unless @header_count.zero?

  ansi_logo = <<-HEREDOC
 __
/\\ \\
\\ \\ \\____ __
 \\ \\  __ \\\\ \\  Bonus Bits
  \\ \\ \\_\\ \\\\ \\____
   \\ \\____/ \\  __ \\
    \\/___/ \\ \\ \\_\\ \\
            \\ \\____/
             \\/___/
  HEREDOC
  print ansi_logo.colorize(:cyan)
  puts "Terraform AWS Orchestrator - v#{File.open('VERSION', &:readline)}".colorize(:light_green)
  puts '------------------------------------------------------------------------'.colorize(:light_green)
  puts '- AWS Region           ('.colorize(:light_green) + (@project_vars['aws_region']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts '- AWS Profile          ('.colorize(:light_green) + (@project_vars['aws_profile']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts '- Deploy Color         ('.colorize(:light_green) + (@project_vars['deploy_color']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts '- TF Workspace         ('.colorize(:light_green) + (@project_vars['tf_workspace']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts '- TF Roles Path        ('.colorize(:light_green) + (@project_vars['tf_roles_path']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts '- TF Role Modules      ('.colorize(:light_green) + (@project_vars['tf_roles']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts '- TFvars Shared File   ('.colorize(:light_green) + (@project_vars['tf_shared_var_file']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts '- TFvars Env File      ('.colorize(:light_green) + (@project_vars['tf_env_var_file']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts '- TFvars Secrets File  ('.colorize(:light_green) + (@project_vars['tf_secrets_file']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  @header_count = 1
end

def sub_header(message)
  # require 'colorize'
  puts ''
  puts '*************************************************************************'.colorize(:light_green)
  puts '* '.colorize(:light_green) + message.to_s.colorize(:cyan)
  puts '*************************************************************************'.colorize(:light_green)
end

def role_footer(role, run_time)
  # require 'colorize'
  puts '------------------------------------------------------------------------'.colorize(:light_green)
  puts 'Finished      ('.colorize(:light_green) + role.to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts 'Run Time:     ('.colorize(:light_green) + run_time.to_s.colorize(:cyan) + ')'.colorize(:light_green)
end

def footer(run_time)
  # require 'colorize'
  puts '------------------------------------------------------------------------'.colorize(:light_green)
  puts 'Workspace     ('.colorize(:light_green) + (@project_vars['tf_workspace']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts 'AWS Region    ('.colorize(:light_green) + (@project_vars['aws_region']).to_s.colorize(:cyan) + ')'.colorize(:light_green)
  puts 'Run Time:     ('.colorize(:light_green) + run_time.to_s.colorize(:cyan) + ')'.colorize(:light_green)
end

def time_diff(start_time, end_time)
  Time.at((start_time - end_time).round.abs).utc.strftime('%H:%M:%S')
end

def press_any_key(action = '', extra_text = true)
  # require 'colorize'
  require 'tty-prompt'
  if extra_text
    puts ''
    puts "/\\/\\ Check Values Above - About to Run (#{action}) /\\/\\".colorize(:yellow)
  end
  puts ''
  TTY::Prompt.new.keypress('Press any Key to Continue...')
end

def render_erb_yml_template(template)
  require 'erb'
  require 'yaml'
  require 'json'

  erb_template = ERB.new(File.read(template)).result
  YAML.safe_load(erb_template).to_json
  # rendered_service = YAML.safe_load(erb_template)
  # Write Rendered Config Data to file
  # File.open(template, 'w') { |file| file.write(rendered_service.to_yaml) }
end

def run_command(shell_command)
  # Will not show output until completed which sucks if want to watch the progress.
  require 'open3'
  out, err, status = Open3.capture3(shell_command, sensitive = false)

  successful = status.success?
  unless successful
    puts('ERROR: Unsuccessful Command')
    puts("Open3: Shell Command (#{shell_command})") unless sensitive
    puts("Open3: Status (#{status})")
    puts("Open3: Standard Out (#{out})") unless sensitive
    puts("Open3: Successful? (#{successful})")
    puts("Open3: Error Out (#{err})") unless successful
  end
  status.success?
end

def run_command_strout(shell_command, sensitive = false)
  # Will not show output until completed which sucks if want to watch the progress.
  require 'open3'
  out, err, status = Open3.capture3(shell_command)
  successful = status.success?
  unless successful
    puts('ERROR: Unsuccessful Command')
    puts("Open3: Shell Command (#{shell_command})") unless sensitive
    puts("Open3: Status (#{status})")
    puts("Open3: Standard Out (#{out})")
    puts("Open3: Successful? (#{successful})")
    puts("Open3: Error Out (#{err})")
  end
  puts out
end

def show_vars
  puts 'Project Variables'
  puts '------------------'
  @project_vars.each do |key, value|
    puts "#{key}: #{value}"
  end
end
