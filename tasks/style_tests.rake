# frozen_string_literal: true

# Style tests. Rubocop
namespace :style do
  require 'rubocop/rake_task'

  desc 'RuboCop'
  RuboCop::RakeTask.new(:ruby)
end

desc 'Alias (style:ruby)'
task style_tests: %w[style:ruby]
