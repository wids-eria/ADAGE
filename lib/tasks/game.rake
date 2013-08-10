namespace :games do 
  desc 'Safely update and create the game and implementation models from what data has been logged'
  task :build => :environment do
    game_names = AdaData.all.distinct(:gameName)
    if game_names.empty?
      puts 'No game data found'
    end
    
    puts 'Games: ' + game_names.to_s

    game_names.each do |name|
      #create the game if it doesn't exist
      if name != nil
        game = Game.where(name: name)
        if game.empty?
          puts 'Creating model for game: ' + name
          Game.create(name: name)
        else
          puts 'Found existing Model for game: ' + name
        end
        
        #now update the game versions
        game_data = AdaData.where(gameName: name)
        versions = game_data.distinct(:schema)
        versions.each do |v_name|
          if Implementation.where(name: v_name).empty?
            puts 'Creating Model for Game version: ' + name + ':' + v_name
            Implementation.create(name: v_name, game: game.first)
          else
            puts 'Found existing model for game version: ' + name + ':' + v_name
          end
        end
      end
    
    end
  end

end
