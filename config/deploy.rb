require "dotenv/capistrano"

set :application, "crowdreplay"
set :deploy_to, "/home/jwnichls/web/crowdreplay"
set :use_sudo, false

set :repository,  "git@github.com:jwnichls/crowdreplay.git"

set :user, "jwnichls"                    # define the user account
set :domain, "crowdreplay.com"         # define our domain
server domain, :web, :app                # define that our domain is where the app and web servers are
role :db, domain, :primary => true       # This is where Rails migrations will run

# ==============================
# Deploy
# ==============================

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
