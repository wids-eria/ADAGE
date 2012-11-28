set :rails_env, :staging
set :rvm_type, :system
set :branch, "adventurous_aardvark"

role :web, "eria-1.morgridge.net"
role :app, "eria-1.morgridge.net"
role :db,  "eria-1.morgridge.net", :primary => true # This is where Rails migrations will run

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && touch tmp/restart.txt"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && touch tmp/restart.txt"
  end
end
