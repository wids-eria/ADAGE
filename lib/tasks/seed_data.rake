namespace :seed_data do
  desc 'Cleans fake data from Fake Game'
  task :clean => :environment do
    db = Mongoid::Sessions.default
    collection = db['Fake_Game']
    collection.drop

    collection = db['fake_game']
    collection.drop
  end

  desc 'Creates fake data from a fake game so we can test data tools locally'
  task :create_dd => :environment do

    rand = Random.new(Time.now.to_i)

    client_token = ''
    game = Game.where('lower(name) = ?', 'fake game').first

    if game != nil
      imp = game.implementations.first
      if imp != nil
        client_token = imp.client.app_token
      end
    end

    adage_context = {'name' => 'find_a_candy', 'parent_name' => 'find_a_candy'}

    adage_vc =    {
                    'active_units' =>  ['forest', 'find_a_candy'],
                    'level' => 'super awesome level'
                  }
    adage_pc =
                  {
                    'x' => rand.rand(0...100),
                    'y' => rand.rand(0...100),
                    'z' => rand.rand(0...100),
                    'rotx' => rand.rand(0...100),
                    'roty' => rand.rand(0...100),
                    'rotz' => rand.rand(0...100)
                  }

    adage_base = {'gameName' => 'Fake Game',
                 'gameVersion' => client_token,
                 'ADAVersion' => 'drunken_dolphin',
                 'timestamp' => Time.now.to_i,
                 'session_token' => Time.now.to_s,
                 'ada_base_types' => ['ADAGEData', 'ADAGEGameEvent', 'ADAGEPlayerEvent'],
                 'key' => 'FGPlayerEvent',
                 'ADAGEVirtualContext' => adage_vc,
                 'ADAGEPositionalContext' => adage_pc,
                 'user_id' => rand.rand(1..User.all.count)
                  }

    adage_start = {'gameName' => 'Fake Game',
                 'gameVersion' => client_token,
                 'ADAVersion' => 'drunken_dolphin',
                 'timestamp' => Time.now.to_i,
                 'session_token' => Time.now.to_s,
                 'ada_base_types' => ['ADAGEData', 'ADAGEContext', 'ADAGEContextStart'],
                 'key' => 'FGQuestStart',
                 'user_id' => 1,
                 'name' => 'Quest!',
                 'parent_name' => 'Mission',

                  }

    adage_end = {'gameName' => 'Fake Game',
                 'gameVersion' => client_token,
                 'ADAVersion' => 'drunken_dolphin',
                 'timestamp' => Time.now.to_i,
                 'session_token' => Time.now.to_s,
                 'ada_base_types' => ['ADAGEData', 'ADAGEContext', 'ADAGEContextEnd'],
                 'key' => 'FGQuestEnd',
                 'user_id' => 1,
                 'name' => 'Quest!',
                 'parent_name' => 'Mission',
                 'success' => true,
                 'health' => rand.rand(0..20)
                  }



     start_time = Time.now - rand.rand(0..5) * 1.days
     types = [adage_base, adage_start, adage_end]
     quest_names = ['Find the Thing', 'Resuce the Prince', 'slay the dragon']
     success = [true, false, true, false, true, false]
     (0..10).each do |i|
        data = AdaData.with_game("Fake Game").new(types[rand.rand(0...types.count)])
        data.user_id = rand.rand(1..User.all.count)
        puts 'creating data for ' + data.user_id.to_s
        data.session_token = start_time.to_s
        data.timestamp = ((start_time + (1.minute * rand.rand(1..50))).to_i * 1000).to_s
        if data.key.include?('FGQuest')
          data.name = quest_names[rand.rand(0...quest_names.count)]
        end

        if data.key.include?('FGQuestEnd')
          data.success = success[rand.rand(0...success.count)]
        end
        data.save
     end

    #Add indices to collection
    db = Mongoid::Sessions.default
    gamename = 'Fake_Game'.downcase
    collection = db[gamename]
    collection.indexes.create(name: 1)
    collection.indexes.create(gameName: 1)
    collection.indexes.create(user_id: 1)
    collection.indexes.create(timestamp: 1)

  end

  desc 'Creates fake electric eel data from a fake game so we can test data tools locally'
  task :create_ee => :environment do

    rand = Random.new(Time.now.to_i)

    client_token = ''
    game = Game.where('lower(name) = ?', 'fake game').first

    if game != nil
      imp = game.implementations.first
      if imp != nil
        client_token = imp.client.app_token
      end
    end

    adage_context = {'name' => 'find_a_candy', 'parent_name' => 'find_a_candy'}

    adage_vc =    {
                    'active_units' =>  ['forest', 'find_a_candy'],
                    'level' => 'super awesome level'
                  }
    adage_pc =
                  {
                    'x' => rand.rand(0...100),
                    'y' => rand.rand(0...100),
                    'z' => rand.rand(0...100),
                    'rotx' => rand.rand(0...100),
                    'roty' => rand.rand(0...100),
                    'rotz' => rand.rand(0...100)
                  }

    adage_base = {'application_name' => 'Fake Game',
                 'application_version' => client_token,
                 'adage_version' => 'electric_eel',
                 'timestamp' => Time.now.to_i,
                 'session_token' => Time.now.to_s,
                 'ada_base_types' => ['ADAGEData', 'ADAGEGameEvent', 'ADAGEPlayerEvent'],
                 'key' => 'FGPlayerEvent',
                 'ADAGEVirtualContext' => adage_vc,
                 'ADAGEPositionalContext' => adage_pc,
                 'user_id' => rand.rand(1..User.all.count),
                 'game_id' => 'fake_game'
                  }

    adage_start = {'application_name' => 'Fake Game',
                 'application_version' => client_token,
                 'adage_version' => 'electric_eel',
                 'timestamp' => Time.now.to_i,
                 'session_token' => Time.now.to_s,
                 'ada_base_types' => ['ADAGEData', 'ADAGEContext', 'ADAGEContextStart'],
                 'key' => 'FGQuestStart',
                 'user_id' => 1,
                 'name' => 'Quest!',
                 'parent_name' => 'Mission',
                 'game_id' => 'fake_game'

                  }

    adage_end = {'application_name' => 'Fake Game',
                 'application_version' => client_token,
                 'adage_version' => 'electric_eel',
                 'timestamp' => Time.now.to_i,
                 'session_token' => Time.now.to_s,
                 'ada_base_types' => ['ADAGEData', 'ADAGEContext', 'ADAGEContextEnd'],
                 'key' => 'FGQuestEnd',
                 'user_id' => 1,
                 'name' => 'Quest!',
                 'parent_name' => 'Mission',
                 'success' => true,
                 'health' => rand.rand(0..20),
                 'game_id' => 'fake_game'
                  }


     start_time = (Time.now.to_f*1000).to_i
     types = [adage_base, adage_start, adage_end]
     quest_names = ['Find the Thing', 'Resuce the Prince', 'slay the dragon']
     success = [true, false, true, false, true, false]


     (0..10000).each do |i|
        data = AdaData.with_game("Fake Game").new(types[rand.rand(0...types.count)])
        data.user_id = User.all.sample.id
        unless User.where(id: data.user_id).first.nil?
            if data.user_id == 4
                puts "ASDASDASDASNOIDASDOIADSNI"
            end
            puts 'creating data for ' + data.user_id.to_s
            data.session_token = start_time.to_s
            data.timestamp = ((start_time ))
            if data.key.include?('FGQuest')
              data.name = quest_names[rand.rand(0...quest_names.count)]
            end

            if data.key.include?('FGQuestEnd')
              data.success = success[rand.rand(0...success.count)]
              data.health = rand.rand(4...20)
            end
            data.save
        end
     end

    #Add indices to collection
    db = Mongoid::Sessions.default
    gamename = 'Fake_Game'.downcase
    collection = db[gamename]
    collection.indexes.create(name: 1)
    collection.indexes.create(gameName: 1)
    collection.indexes.create(user_id: 1)
    collection.indexes.create(timestamp: 1)

  end
end
