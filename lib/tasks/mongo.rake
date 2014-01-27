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
end
