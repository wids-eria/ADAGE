set :rails_env, :staging
set :branch, "cooler_cougar"

role :web, "eria-1.morgridge.net"
role :app, "eria-1.morgridge.net"
role :db,  "eria-1.morgridge.net", :primary => true # This is where Rails migrations will run
