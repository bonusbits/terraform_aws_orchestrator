# require 'FileUtils'

namespace :secrets do
  desc 'Generate AWS SSH Keys that Terraform Can Upload to AWS'
  task :create_all_ssh_keys do
    disable_create_ssh_keys = @project_vars['disable_create_ssh_keys'].nil? ? false : @project_vars['disable_create_ssh_keys']
    if disable_create_ssh_keys
      puts 'INFO: Create SSH Keys is Disabled in Rake Vars'
    else

      header
      sub_header('Create SSH Keys')
      # Static Location so TF Network Module Knows the Location without a TF Env Vars
      keys_path = "vars/secrets/#{@project_vars['tf_workspace']}"
      FileUtils.mkdir_p keys_path

      key_list = %w[
        backend_instances
        bastion
        frontend_instances
      ]
      # Private Frontend Keys
      key_list.each do |key|
        if File.exist?("#{keys_path}/#{key}")
          puts "INFO: Already Created (#{keys_path}/#{key})"
        else
          puts "INFO: Creating... (#{keys_path}/#{key})!"
          system "ssh-keygen -t rsa -f #{keys_path}/#{key} -q -N ''"
        end
      end
    end
  end
end
