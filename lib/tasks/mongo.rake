namespace :mongo do
    desc "Add indexes to each Game collection"
    task :create_indexes  => :environment do
        db = Mongoid::Sessions.default

        Game.all.each do |game|
          gamename = game.name.to_s.gsub(' ', '_').downcase
          collection = db[gamename]
          collection.indexes.create(name: 1)
          collection.indexes.create(gameName: 1)
          collection.indexes.create(user_id: 1)
          collection.indexes.create(timestamp: 1)
          collection.indexes.create(startContextID: 1)
          puts "Added indices to #{gamename}"
        end
    end

    desc "Convert Mongo collection names to lowercase for case insensitivte querying"
    task :lowercase_collections  => :environment do
        db = Mongoid::Sessions.default

        db.collections.each do |coll|
          from = coll.name.to_s.gsub(' ', '_')
          to = from.downcase

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

    desc "Merges APA:tracts into apa:tracts"
    task :merge_apa  => :environment do
        db = Mongoid::Sessions.default
        db_initial = db["APA:Tracts"]
        db_final = db["apa:tracts"]

        size = db_initial.find().count() + db_final.find().count()

        db_initial.find().each do |log|
          db_final.insert(log)
        end

        if size >=  db_final.find().count()
          puts "ERROR: Collections did not merge!"
        end
    end
end
