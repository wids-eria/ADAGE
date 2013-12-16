namespace :mongo_migrate do
    desc 'Splits the AdaData collection into a collection per game'
    task :split => :environment do

        db = Mongoid::Sessions.default
        db.use :ada_development
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
                puts "Warning! Only " + db[gamename].find.count.to_s + "/" + total.to_s + " records transferred"
            end
        end
    end

    desc 'Removes AdaData collection from database'
    task :clean => :environment do
        db = Mongoid::Sessions.default
        db.use :ada_development
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
            puts "Removing AdaData"
        else
            puts "Did not remove AdaData: Total game records do not equal AdaData totals " + db[:ada_data].find.count.to_s + "/" + total.to_s
        end
    end
end
