set :rails_env, :staging
set :branch, "master"

role :web, "terrordome.discovery.wisc.edu"
role :app, "terrordome.discovery.wisc.edu"
role :db,  "terrordome.discovery.wisc.edu", :primary => true # This is where Rails migrations will run

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    raise 'wow'
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    raise 'weee'
  end
end
