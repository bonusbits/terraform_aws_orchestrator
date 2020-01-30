# frozen_string_literal: true

def load_project_vars
  require 'yaml'
  # TODO: Temp raise until have default config local/dev or whatever created
  # raise 'ERROR: Missing DEPLOY_ENV environment variable' unless ENV['DEPLOY_ENV']
  # deploy_env = ENV.fetch('DEPLOY_ENV', 'local')
  # raise 'ERROR: Missing TF_WORKSPACE environment variable' unless ENV['TF_WORKSPACE']
  if ENV['TF_WORKSPACE']
    puts "Terraform AWS Orchestrator - v#{File.open('VERSION', &:readline)} - TF_WORKSPACE (#{ENV['TF_WORKSPACE']})"
  else
    puts "Terraform AWS Orchestrator - v#{File.open('VERSION', &:readline)})"
  end
  puts '-----------------------------------------------------------------------'
  tf_workspace = ENV.fetch('TF_WORKSPACE', 'demo')
  @project_vars = YAML.load_file(File.join(__dir__, '../vars/shared.yml'))
  @project_vars = @project_vars.merge(YAML.load_file(File.join(__dir__, "../vars/#{tf_workspace.downcase}.yml")))
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
