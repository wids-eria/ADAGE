set :rvm_type, :system
Deploy_host = "eria-1.morgridge.net"

set :rvm_ruby_string, '1.9.3'

require 'capistrano/ext/multistage'
set :stages, %w(production staging)
set :default_stage, "staging"

require 'bundler/capistrano'
load 'deploy/assets'

set :application, "ada"

set :scm, :git
set :repository,  "git@github.com:wids-eria/ada.git"
set :branch, "master"

role :web, Deploy_host
role :app, Deploy_host
role :db,  Deploy_host, :primary => true # This is where Rails migrations will run

set :user, :deploy
set :deploy_to, "/home/deploy/applications/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
ssh_options[:forward_agent] = true

set :normalize_asset_timestamps, false


# CALLBACKS #########

after 'deploy:finalize_update', 'deploy:symlink_db'
after 'deploy:finalize_update', 'deploy:symlink_unity_crossdomain'

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end

  desc "Symlink crossdomain.xml"
  task :symlink_unity_crossdomain do
    run "ln -nfs #{deploy_to}/shared/config/crossdomain.xml #{release_path}/public/crossdomain.xml"
  end

  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && touch tmp/restart.txt"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && touch tmp/restart.txt"
  end
end
