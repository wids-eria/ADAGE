namespace :mongo_migrate do
    desc 'Splits the AdaData collection into a collection per game'
    task :split => :environment do

        db = Mongoid::Sessions.default
        db.use :ada_development_dash

        collection = db[:ada_data]

        games = collection.find.distinct(:gameName)

        games.each do |game|
            gamename = game.to_s.gsub(' ', '_')

            puts "Making collection " + gamename

            total = collection.find(gameName: game).count
            collection.find(gameName: game).each do |data|
                db[gamename].insert([data])
            end

            if total != db[gamename].find.count
                puts "Warning! " + db[gamename].find.count.to_s + " records found, expected " + total.to_s
            end
        end
    end

    desc 'Removes AdaData collection from database'
    task :clean => :environment do
        db = Mongoid::Sessions.default
        db.use :ada_development_dash
        collection = db[:ada_data]

        games = collection.find.distinct(:gameName)

        #Get the total records accorss all game specific collections
        total = 0
        games.each do |game|
            gamename = game.to_s.gsub(' ', '_')
            total += db[gamename].find.count
        end

        #Compare total game records to AdaData count to  ake sure none are missing
        if total == db[:ada_data].find.count
           # puts "Removing AdaData"
        else
            puts "Did not remove AdaData: Total game records do not equal AdaData totals " + db[:ada_data].find.count.to_s + "/" + total.to_s
        end
    end

    desc 'Upgrades the record _id format to uniformly use ObjectId rather than strings'
    task :migrate_ids => :environment do
        db = Mongoid::Sessions.default
        db.use :ada_development_dash

        puts "Starting"
        db.collections.each do |collection|
            #swap to admin database to run commands
            db.use :admin
            database_name = "ada_development_dash"

            from = collection.name
            to =collection.name+"_original"
            puts "Renaming #{from} to #{to}"
            begin
                db.command(renameCollection: "#{database_name}.#{from}", to: "#{database_name}.#{to}")

                #swap back to db for records
                db.use :ada_development_dash                   
                new_collection = db[from]
                new_collection.drop
                puts "Migration collection #{collection.name}"

                db[to].find.each do |document|                
                    document["_id"] = Moped::BSON::ObjectId(document["_id"])
                    #puts document["_id"]
                    new_collection.insert(document, :safe => true)
                end

                db[to].drop
            rescue
                puts "Cannot convert collection #{from} to #{to}"
            end

        end
    end
end