# frozen_string_literal: true

namespace :deploy do
  desc 'Create Entire Stack with Terraform (Based on Env Vars)'
  task :tf_stack do
    require 'highline/import'
    header
    press_any_key('Keys, Init & Apply')
    start_time = Time.now
    Rake::Task['secrets:create_all_ssh_keys'].execute
    Rake::Task['terraform:init'].execute
    Rake::Task['terraform:apply'].execute
    end_time = Time.now
    run_time = time_diff(start_time, end_time)
    footer(run_time)
  end

  desc 'Create SSH Keys, Run Terraform Init & Plan'
  task :tf_prep do
    header
    press_any_key('Keys, Init & Plan')
    start_time = Time.now
    Rake::Task['secrets:create_all_ssh_keys'].execute
    Rake::Task['terraform:init'].execute
    Rake::Task['terraform:plan'].execute
    end_time = Time.now
    run_time = time_diff(start_time, end_time)
    footer(run_time)
  end

  # Pre-Defined Workspace and AWS Region
  namespace :predefined do
    desc 'Deploy Example VPC Dev to USW2 Blue'
    task :example_vpc_dev_usw1_blue do
      fetch_env_vars('example_vpc_dev_usw2', 'us-west-2', 'blue')
      load_yaml_vars('example_vpc_dev_usw2')
      Rake::Task['deploy:tf_stack'].execute
    end

    desc 'Deploy Example VPC Dev to USW2 Green'
    task :example_vpc_dev_usw2_green do
      fetch_env_vars('example_vpc_dev_usw2', 'us-west-2', 'green')
      load_yaml_vars('example_vpc_dev_usw2')
      Rake::Task['deploy:tf_stack'].execute
    end
    desc 'Deploy Example VPC Prd to USW2 Blue'
    task :example_vpc_prd_usw1_blue do
      fetch_env_vars('example_vpc_prd_usw2', 'us-west-2', 'blue')
      load_yaml_vars('example_vpc_prd_usw2')
      Rake::Task['deploy:tf_stack'].execute
    end

    desc 'Deploy Example VPC Prod to USW2 Green'
    task :example_vpc_prd_usw2_green do
      fetch_env_vars('example_vpc_prd_usw2', 'us-west-2', 'green')
      load_yaml_vars('example_vpc_prd_usw2')
      Rake::Task['deploy:tf_stack'].execute
    end
  end
end

desc 'Alias (deploy:tf_stack)'
task up: %w[deploy:tf_stack]

desc 'Alias (deploy:tf_prep)'
task prep: %w[deploy:tf_prep]
