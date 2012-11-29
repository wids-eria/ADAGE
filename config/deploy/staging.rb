set :rails_env, :staging
set :branch, "master"

role :web, "terrordome.discovery.wisc.edu"
role :app, "terrordome.discovery.wisc.edu"
role :db,  "terrordome.discovery.wisc.edu", :primary => true # This is where Rails migrations will run

set :passenger_port, 9292
def passenger_cmd(environment)
  "RAILS_ENV=#{environment} bundle exec passenger"
end

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{passenger_cmd(rails_env)} start -e #{rails_env} -p #{passenger_port} -d"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{passenger_cmd(rails_env)} stop -p #{passenger_port}"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run <<-CMD
      if [[ -f #{current_path}/tmp/pids/passenger.#{passenger_port}.pid ]];
      then
        cd #{current_path} && #{passenger_cmd(rails_env)} stop -p #{passenger_port};
      fi
    CMD

    run "cd #{current_path} && #{passenger_cmd(rails_env)} start -e #{rails_env} -p #{passenger_port} -d"
  end
end
