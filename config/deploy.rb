set :rvm_ruby_string, '1.9.3'

require 'bundler/capistrano'
load 'deploy/assets'

require 'capistrano/ext/multistage'
set :stages, %w(production staging)
set :default_stage, "staging"

set :application, "ada"
set :repository,  "git@github.com:wids-eria/ada.git"
set :scm, :git

set :user, :deploy
ssh_options[:forward_agent] = true

set :deploy_to, "/home/deploy/applications/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

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
end
