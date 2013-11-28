set :rails_env, :development
set :branch, "master"

role :web, "gls-devel-1.discovery.wisc.edu"
role :app, "gls-devel-1.discovery.wisc.edu"
role :db,  "gls-devel-1.discovery.wisc.edu", :primary => true # This is where Rails migrations will run
