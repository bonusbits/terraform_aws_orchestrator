namespace :undeploy do
  desc 'Delete Environment Based on DEPLOY_ENV environment variable'
  task :tf do
    Rake::Task['terraform:destroy_var_file'].execute
  end
end

desc 'Alias (undeploy:tf)'
task utf: %w[undeploy:tf]
