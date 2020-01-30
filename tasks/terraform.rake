namespace :terraform do
  tf_var_file = @project_vars['tf_var_file']
  tf_root_path = @project_vars['tf_root_path']

  desc 'Deploy Environment Based on DEPLOY_ENV environment variable'
  task :apply_var_file do
    Rake::Task['terraform:init'].execute
    sh "terraform apply -auto-approve -parallelism=20 -refresh=true -compact-warnings -var-file=#{tf_var_file} #{tf_root_path}"
  end

  desc 'Deploy Environment Based on DEPLOY_ENV environment variable'
  task :plan_var_file do
    Rake::Task['terraform:init'].execute
    sh "terraform plan -var-file=#{tf_var_file} #{tf_root_path}"
  end

  desc 'Terraform Initialization'
  task :init do
    sh "terraform init #{tf_root_path}"
  end

  desc 'List Current State'
  task :list_state do
    sh 'terraform state list'
  end

  desc 'Delete Environment Based on DEPLOY_ENV environment variable'
  task :destroy_var_file do
    sh "terraform destroy -auto-approve -var-file=#{tf_var_file} #{tf_root_path}"
  end

  desc 'Load Terraform Console with Var File Based on DEPLOY_ENV environment variable'
  task :console do
    sh "terraform console -var-file=#{tf_var_file} #{tf_root_path}"
  end
end

desc 'Alias (terraform:list_state)'
task tfl: %w[terraform:list_state]
