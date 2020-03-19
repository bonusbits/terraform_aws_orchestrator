$VERBOSE = nil

# For CircleCI
require 'bundler/setup'

# For Rake Tasks
require 'colorize'
require 'FileUtils'
require 'highline/import'

# Check for Required Environment Vars
unless ENV['CI']
  raise 'ERROR: Missing AWS_PROFILE environment variable'.colorize(:light_red) unless ENV['AWS_PROFILE']
  # raise 'ERROR: Missing DEPLOY_COLOR environment variable'.colorize(:light_red) unless ENV['DEPLOY_COLOR']
  # raise 'ERROR: Missing AWS_REGION environment variable' unless ENV['AWS_REGION']
  # raise 'ERROR: Missing TF_WORKSPACE environment variable' unless ENV['TF_WORKSPACE']
end

# Load Rake Task Helper Methods
require_relative 'tasks/helpers'

Dir.glob('tasks/*.rake').each do |task_file|
  load task_file
end

desc 'Alias (style:ruby:auto_correct)'
task default: %w[style:ruby:auto_correct]

# Defaults using Environment Variables or Defaults that can be overridden
@header_count = 0
fetch_env_vars
load_yaml_vars
@working_directory = Dir.getwd
