set :rails_env, :staging
set :branch, "master"

role :web, "gls-staging-1.discovery.wisc.edu"
role :app, "gls-staging-1.discovery.wisc.edu"
role :db,  "gls-staging-1.discovery.wisc.edu", :primary => true # This is where Rails migrations will run
