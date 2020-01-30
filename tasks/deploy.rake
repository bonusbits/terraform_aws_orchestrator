namespace :deploy do
  desc 'Deploy Environment Based on TF_WORKSPACE environment variable'
  task :tf do
    Rake::Task['terraform:apply_var_file'].execute
  end

  desc 'Run Terraform Init & Plan'
  task :tf_prep do
    Rake::Task['terraform:plan_var_file'].execute
  end
end

desc 'Alias (deploy:tf)'
task dtf: %w[deploy:tf]

desc 'Alias (deploy:tf_prep)'
task tfp: %w[deploy:tf_prep]

desc 'Alias (terraform:init)'
task tfi: %w[terraform:init]
