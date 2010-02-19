require "capistrano_database"

set :domain, "fundip.dreamhost.com"   #the one you ssh into
set :user, "eggbasket" 
set :application, "eggbasket.org"
set :repository,  "git@github.com:kathrynaaker/eggs.git"
set :applicationdir, "/home/#{user}/#{application}"


set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache


role :web, domain                         # Your HTTP server, Apache/etc
role :app, domain # This may be the same as your `Web` server
role :db,  "mysql.kathrynaaker.com", :primary => true # This is where Rails migrations will run

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