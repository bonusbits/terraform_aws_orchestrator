# frozen_string_literal: true

# For CircleCI
require 'bundler/setup'

# Load Rake Task Helper Methods
require_relative 'tasks/helpers'

# Check for Required Environment Vars
raise 'ERROR: Missing TF_WORKSPACE environment variable' unless ENV['TF_WORKSPACE']

# raise 'ERROR: Missing AWS_PROFILE environment variable' unless ENV['AWS_PROFILE']
# raise 'ERROR: Missing AWS_REGION environment variable' unless ENV['AWS_REGION']
# raise 'ERROR: Missing TF_VAR_aws_region environment variable' unless ENV['TF_VAR_aws_region']
# raise 'ERROR: Missing TF_VAR_aws_profile environment variable' unless ENV['TF_VAR_aws_profile']
# raise 'ERROR: Missing TF_VAR_aws_key_name environment variable' unless ENV['TF_VAR_aws_key_name']

# Load Project Variables
load_project_vars

desc 'Show Project Variables from YAML vars Files'
task :show_vars do
  show_vars
end

Dir.glob('tasks/*.rake').each do |task_file|
  load task_file
end

desc 'Alias (style:ruby:auto_correct)'
task default: %w[style:ruby:auto_correct]
