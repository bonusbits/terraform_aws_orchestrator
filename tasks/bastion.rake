# frozen_string_literal: true

namespace :bastion do
  desc 'Login to Bastion Host'
  task :login do
    header
    sub_header('Login to Bastion')
    keys_path = "vars/secrets/#{@project_vars['tf_workspace']}"
    # TODO: Switch to an AWS CLI or Terraform Output query for the EIP instead of writing out file
    bastion_ip = File.readlines("environments/secrets/#{@project_vars['tf_workspace']}/bastion.ip").first.chomp
    system "ssh -o StrictHostKeyChecking=no -i #{keys_path}/bastion ubuntu@#{bastion_ip}"
  end

  desc 'Propagate SSH Keys to Bastion Host'
  task :propagate_keys do
    header
    sub_header('Propagate SSH Keys')
    # Static Location so TF Network Module Knows the Location without a TF Env Vars
    keys_path = "vars/secrets/#{@project_vars['tf_workspace']}"
    # bastion_ip = system "terraform output public_ip_bastion"
    bastion_ip = File.readlines("environments/secrets/#{@project_vars['tf_workspace']}/bastion.ip").first.chomp

    key_list = %w[
      backend-instances
      frontend-instances
    ]
    key_list.each do |key|
      puts "INFO: Uploading (#{keys_path}/#{key})!"
      system "scp -o StrictHostKeyChecking=no -i #{keys_path}/bastion #{keys_path}/#{key} ubuntu@#{bastion_ip}:~/.ssh/"
    end
  end

  # desc 'Add Some Administration BASH Functions'
  # task :add_functions do
  #   header
  #   sub_header('Deploy BASH Functions')
  #   # Static Location so TF Network Module Knows the Location without a TF Env Vars
  #   keys_path = "vars/secrets/#{@project_vars['tf_workspace']}"
  #   script_path = 'scripts/bastion_functions.sh'
  #   # bastion_ip = system "terraform output public_ip_bastion"
  #   puts "INFO: Uploading (#{script_path})!"
  #   system "scp -o StrictHostKeyChecking=no -i #{keys_path}/bastion #{script_path} ubuntu@13.52.117.169:~/.bash_aliases"
  # end
  #
  # desc 'Setup New Bastion Host'
  # task setup: %w[bastion:propagate_keys bastion:add_functions]
end

desc 'Alias (bastion:login)'
task login: %w[bastion:login]