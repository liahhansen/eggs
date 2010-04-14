
set :user, 'eggbasket'  # Your dreamhost account's username
set :domain, 'addisababa.dreamhost.com'  # Dreamhost servername where your account is located
set :application, 'eggbasket.org'  # Your app's location (domain or sub-domain name as setup in panel)
set :applicationdir, "/home/#{user}/#{application}"  # The standard Dreamhost setup

# version control config
set :scm, :git
set :repository,  "git://github.com/kathrynaaker/eggs.git"

set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

set :scm_command, "~/packages/bin/git" #updated version of git on ?server in user directory
set :local_scm_command, "git" #correct path to local ?git

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache

# additional settings
set :use_sudo, false



# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:symlink" do
  run "cp #{File.join(shared_path, 'config', 'database.yml')} #{File.join(current_path, 'config', 'database.yml')}"
  run "cp #{File.join(shared_path, 'config', 'backup.rb')} #{File.join(current_path, 'config', 'backup.rb')}"  
  run "cp #{File.join(shared_path, 'config', 'newrelic.yml')} #{File.join(current_path, 'config', 'newrelic.yml')}"  
  run "cp #{File.join(shared_path, 'config', 'production.rb')} #{File.join(current_path, 'config', 'environments', 'production.rb')}"
end

after "deploy:symlink", "deploy:update_crontab"
namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && /home/eggbasket/.gem/ruby/1.8/bin/whenever --update-crontab #{application}"
  end
end
