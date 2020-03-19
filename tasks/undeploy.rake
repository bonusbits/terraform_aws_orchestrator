# frozen_string_literal: true

namespace :undeploy do
  desc 'Delete Entire Stack with Terraform (Based on Env Vars)'
  task :tf_stack do
    header
    press_any_key('Terraform Destroy')
    start_time = Time.now
    Rake::Task['terraform:destroy'].execute
    end_time = Time.now
    run_time = time_diff(start_time, end_time)
    footer(run_time)
  end

  # Pre-Defined Workspace and AWS Region
  namespace :predefined do
    desc 'Delete Example US-West-2 DEV Blue'
    task :example_vpc_dev_usw1_blue do
      fetch_env_vars('example_vpc_dev_usw2', 'us-west-2', 'blue')
      load_yaml_vars('example_vpc_dev_usw2')
      Rake::Task['undeploy:tf_stack'].execute
    end

    desc 'Delete Example US-West-2 DEV Green'
    task :example_vpc_dev_usw2_green do
      fetch_env_vars('example_vpc_dev_usw2', 'us-west-2', 'green')
      load_yaml_vars('example_vpc_dev_usw2')
      Rake::Task['undeploy:tf_stack'].execute
    end

    desc 'Delete Example PRD US-West-2 Blue'
    task :example_vpc_prd_usw1_blue do
      fetch_env_vars('example_vpc_prd_usw2', 'us-west-2', 'blue')
      load_yaml_vars('example_vpc_prd_usw2')
      Rake::Task['undeploy:tf_stack'].execute
    end

    desc 'Delete Example PRD US-West-2 Green'
    task :example_vpc_prd_usw2_green do
      fetch_env_vars('example_vpc_prd_usw2', 'us-west-2', 'green')
      load_yaml_vars('example_vpc_prd_usw2')
      Rake::Task['undeploy:tf_stack'].execute
    end
  end
end

desc 'Alias (undeploy:tf_stack)'
task down: %w[undeploy:tf_stack]
