# frozen_string_literal: true

namespace :terraform do
  # require 'highline/import'

  desc 'Run Terraform Apply'
  task :apply do
    header
    aws_region = "AWS_REGION=#{@project_vars['aws_region']} AWS_DEFAULT_REGION=#{@project_vars['aws_region']}"
    aws_profile = "AWS_PROFILE=#{@project_vars['aws_profile']}"
    tf_workspace = "TF_WORKSPACE=#{@project_vars['tf_workspace']}"
    disable_prompt = @project_vars['disable_continue_prompt'].nil? ? false : @project_vars['disable_continue_prompt']
    puts 'INFO: Continue Prompt Disabled in Rake Vars' if disable_prompt

    @project_vars['tf_roles'].each do |tf_role|
      sub_header("Terraform Apply (#{tf_role})")
      next unless disable_prompt || HighLine.agree("Continue with #{tf_role}? (y/n)")
      start_time = Time.now
      Dir.chdir("#{@project_vars['tf_roles_path']}/#{tf_role}") do
        system "#{tf_workspace} #{aws_region} #{aws_profile} terraform apply -auto-approve -parallelism=20 -refresh=true -compact-warnings -var-file=#{@working_directory}/#{@project_vars['tf_shared_var_file']} -var-file=#{@working_directory}/#{@project_vars['tf_env_var_file']} -var-file=#{@working_directory}/#{@project_vars['tf_secrets_file']}"
      end
      end_time = Time.now
      run_time = time_diff(start_time, end_time)
      role_footer(tf_role, run_time)
    end
  end

  desc 'Run Terraform Console'
  task :console do
    header
    sub_header('Terraform Console')
    aws_region = "AWS_REGION=#{@project_vars['aws_region']} AWS_DEFAULT_REGION=#{@project_vars['aws_region']}"
    aws_profile = "AWS_PROFILE=#{@project_vars['aws_profile']}"
    tf_workspace = "TF_WORKSPACE=#{@project_vars['tf_workspace']}"
    Dir.chdir("#{@project_vars['tf_roles_path']}/#{@project_vars['tf_roles'].first}") do
      system "#{tf_workspace} #{aws_region} #{aws_profile} terraform console -var-file=#{@working_directory}/#{@project_vars['tf_shared_var_file']} -var-file=#{@working_directory}/#{@project_vars['tf_env_var_file']} -var-file=#{@working_directory}/#{@project_vars['tf_secrets_file']}"
    end
  end

  desc 'Destroy Entire Stack'
  task :destroy do
    header
    aws_region = "AWS_REGION=#{@project_vars['aws_region']} AWS_DEFAULT_REGION=#{@project_vars['aws_region']}"
    aws_profile = "AWS_PROFILE=#{@project_vars['aws_profile']}"
    tf_workspace = "TF_WORKSPACE=#{@project_vars['tf_workspace']}"
    @project_vars['tf_roles'].reverse_each do |tf_role|
      sub_header("Terraform Destroy (#{tf_role})")
      next unless HighLine.agree("Continue with #{tf_role}? (y/n)")
      start_time = Time.now
      Dir.chdir("#{@project_vars['tf_roles_path']}/#{tf_role}") do
        system "#{tf_workspace} #{aws_region} #{aws_profile} terraform destroy -auto-approve -var-file=#{@working_directory}/#{@project_vars['tf_shared_var_file']} -var-file=#{@working_directory}/#{@project_vars['tf_env_var_file']} -var-file=#{@working_directory}/#{@project_vars['tf_secrets_file']}"
      end
      end_time = Time.now
      run_time = time_diff(start_time, end_time)
      role_footer(tf_role, run_time)
    end
  end

  desc 'Run Terraform Initialization'
  task :init do
    header
    sub_header('Terraform Init')
    next unless HighLine.agree('Run Init? (y/n)')
    disable_init = @project_vars['disable_init'].nil? ? false : @project_vars['disable_init']
    if disable_init
      puts 'INFO: Terraform Init Disabled in Rake Vars'
    else
      header
      aws_region = "AWS_REGION=#{@project_vars['aws_region']} AWS_DEFAULT_REGION=#{@project_vars['aws_region']}"
      aws_profile = "AWS_PROFILE=#{@project_vars['aws_profile']}"
      tf_workspace = "TF_WORKSPACE=#{@project_vars['tf_workspace']}"

      @project_vars['tf_roles'].each do |tf_role|
        sub_header("Terraform Init (#{tf_role})")
        Dir.chdir("#{@project_vars['tf_roles_path']}/#{tf_role}") do
          system "#{tf_workspace} #{aws_region} #{aws_profile} terraform init"
        end
      end
    end
  end

  desc 'Upgrade Terraform Providers'
  task :init_upgrade do
    header
    sub_header('Terraform Init Upgrade')
    aws_region = "AWS_REGION=#{@project_vars['aws_region']} AWS_DEFAULT_REGION=#{@project_vars['aws_region']}"
    aws_profile = "AWS_PROFILE=#{@project_vars['aws_profile']}"
    tf_workspace = "TF_WORKSPACE=#{@project_vars['tf_workspace']}"
    @project_vars['tf_roles'].each do |tf_role|
      sub_header("Terraform Init Upgrade (#{tf_role})")
      Dir.chdir("#{@project_vars['tf_roles_path']}/#{tf_role}") do
        system "#{tf_workspace} #{aws_region} #{aws_profile} terraform init -upgrade"
      end
    end
  end

  desc 'Run Terraform Plan'
  task :plan do
    header
    aws_region = "AWS_REGION=#{@project_vars['aws_region']} AWS_DEFAULT_REGION=#{@project_vars['aws_region']}"
    aws_profile = "AWS_PROFILE=#{@project_vars['aws_profile']}"
    tf_workspace = "TF_WORKSPACE=#{@project_vars['tf_workspace']}"

    @project_vars['tf_roles'].each do |tf_role|
      sub_header("Terraform Plan (#{tf_role})")
      Dir.chdir("#{@project_vars['tf_roles_path']}/#{tf_role}") do
        next unless HighLine.agree("Continue with #{tf_role}? (y/n)")

        system "#{tf_workspace} #{aws_region} #{aws_profile} terraform plan -var-file=#{@working_directory}/#{@project_vars['tf_shared_var_file']} -var-file=#{@working_directory}/#{@project_vars['tf_env_var_file']} -var-file=#{@working_directory}/#{@project_vars['tf_secrets_file']}"
      end
    end

    # working_directory = File.basename(Dir.getwd)
    # puts "DEBUG: Working Directory (#{working_directory})"
  end

  desc 'Display Terraform Providers'
  task :providers do
    header
    aws_region = "AWS_REGION=#{@project_vars['aws_region']} AWS_DEFAULT_REGION=#{@project_vars['aws_region']}"
    aws_profile = "AWS_PROFILE=#{@project_vars['aws_profile']}"
    tf_workspace = "TF_WORKSPACE=#{@project_vars['tf_workspace']}"
    @project_vars['tf_roles'].each do |tf_role|
      sub_header("Terraform Providers (#{tf_role})")
      Dir.chdir("#{@project_vars['tf_roles_path']}/#{tf_role}") do
        # next unless HighLine.agree("Continue with #{tf_root_module}? (y/n)")
        system "#{tf_workspace} #{aws_region} #{aws_profile} terraform providers"
      end
    end
  end

  desc 'Refresh Terraform State'
  task :refresh do
    header
    sub_header('Terraform Refresh')
    aws_region = "AWS_REGION=#{@project_vars['aws_region']} AWS_DEFAULT_REGION=#{@project_vars['aws_region']}"
    aws_profile = "AWS_PROFILE=#{@project_vars['aws_profile']}"
    tf_workspace = "TF_WORKSPACE=#{@project_vars['tf_workspace']}"
    @project_vars['tf_roles'].each do |tf_role|
      sub_header("Terraform Refresh (#{tf_role})")
      Dir.chdir("#{@project_vars['tf_roles_path']}/#{tf_role}") do
        next unless HighLine.agree("Continue with #{tf_role}? (y/n)")

        system "#{tf_workspace} #{aws_region} #{aws_profile} terraform refresh -var-file=#{@working_directory}/#{@project_vars['tf_shared_var_file']} -var-file=#{@working_directory}/#{@project_vars['tf_env_var_file']} -var-file=#{@working_directory}/#{@project_vars['tf_secrets_file']}"
      end
    end
  end

  desc 'Validate Terraform Configurations'
  task :validate do
    header
    aws_region = "AWS_REGION=#{@project_vars['aws_region']} AWS_DEFAULT_REGION=#{@project_vars['aws_region']}"
    aws_profile = "AWS_PROFILE=#{@project_vars['aws_profile']}"
    tf_workspace = "TF_WORKSPACE=#{@project_vars['tf_workspace']}"
    @project_vars['tf_roles'].each do |tf_role|
      sub_header("Terraform Validate (#{tf_role})")
      Dir.chdir("#{@project_vars['tf_roles_path']}/#{tf_role}") do
        system "#{tf_workspace} #{aws_region} #{aws_profile} terraform validate"
      end
    end
  end

  desc 'Display Terrafrom Workspaces'
  task :workspaces do
    header
    sub_header('Terraform Workspaces')
    aws_region = "AWS_REGION=#{@project_vars['aws_region']} AWS_DEFAULT_REGION=#{@project_vars['aws_region']}"
    aws_profile = "AWS_PROFILE=#{@project_vars['aws_profile']}"
    tf_workspace = "TF_WORKSPACE=#{@project_vars['tf_workspace']}"
    Dir.chdir("#{@project_vars['tf_roles_path']}/#{@project_vars['tf_roles'].first}") do
      system "#{tf_workspace} #{aws_region} #{aws_profile} terraform workspace list"
    end
  end
end

desc 'Alias (terraform:apply)'
task apply: %w[terraform:apply]

desc 'Alias (terraform:console)'
task console: %w[terraform:console]

desc 'Alias (terraform:destroy)'
task destroy: %w[terraform:destroy]

desc 'Alias (terraform:init)'
task init: %w[terraform:init]

desc 'Alias (terraform:plan)'
task plan: %w[terraform:plan]

desc 'Alias (terraform:providers)'
task providers: %w[terraform:providers]

desc 'Alias (terraform:refresh)'
task refresh: %w[terraform:refresh]

desc 'Alias (terraform:show)'
task show: %w[terraform:show]

desc 'Alias (terraform:workspaces)'
task workspaces: %w[terraform:workspaces]
