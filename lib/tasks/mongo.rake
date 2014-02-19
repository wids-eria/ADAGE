namespace :mongo do
    desc "Add indexes to each Game collection"
    task :create_indexes  => :environment do
        db = Mongoid::Sessions.default
       #db.use :ada_development

        Game.all.each do |game|
          gamename = game.name.to_s.gsub(' ', '_')
          collection = db[gamename]
          collection.indexes.create(name: 1)
          collection.indexes.create(gameName: 1)
          collection.indexes.create(user_id: 1)
          collection.indexes.create(timestamp: 1)
        end
    end

    desc "Convert Mongo collection names to lowercase for case insensitivte querying"
    task :lowercase_collections  => :environment do
        db = Mongoid::Sessions.default

        db.collections.each do |coll|
          session = Mongoid.default_session
          database_name = session.options[:database]
          begin
            if from != to
              session.with(database: 'admin').command(renameCollection: "#{database_name}.#{from}", to: "#{database_name}.#{to}")
            end
          rescue
            puts "Cannot convert collection #{from} to #{to}"
          end
        end
    end
end
