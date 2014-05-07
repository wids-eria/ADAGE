require 'csv'

def mean(array)
  array.inject(0) { |sum, x| sum += x } / array.size.to_f
end

def mean_and_standard_deviation(array)
  m = mean(array)
  variance = array.inject(0) { |variance, x| variance += (x - m) ** 2 }
  return [m, Math.sqrt(variance/(array.size-1))]
end


#ids = AdaData.with_game('Tenacity-Meditation').only(:user_id).distinct(:user_id)
#players = User.where(id: ids)

player_list = CSV.open("csv/tenacity/player_list.csv", 'r')
players = Array.new
player_list.each do |player_name|
  player = User.where(player_name: player_name).first
  if player != nil
    players << player
  end
end



players.each do |play|
  data = play.data('Tenacity-Meditation').in(key: ['TenTouchEvent', 'TenStageStart', 'TenBreathCycleEnd'] ).without([:_id, :created_at, :updated_at]).asc(:timestamp)
  if data.count > 0
    
    tccsv = CSV.open("csv/tenacity/average_breath_from_cleaned_touch_"+play.email+".csv", "w")
    tcsv = CSV.open("csv/tenacity/average_breath_from_touch_"+play.email+".csv", "w")
    dccsv = CSV.open("csv/tenacity/average_breath_from_touch_difference_cleaned_"+play.email+".csv", "w")
    dcsv = CSV.open("csv/tenacity/average_breath_from_touch_difference_"+play.email+".csv", "w")
    ccsv = CSV.open("csv/tenacity/average_breath_from_end_cycle_"+play.email+".csv", "w")

    tccsv << ['name', 'session', 'scores'] 
    tcsv << ['name', 'session', 'scores'] 
    dccsv << ['name', 'session', 'scores'] 
    dcsv << ['name', 'session', 'scores'] 
    ccsv << ['name', 'session', 'scores'] 

    puts play.player_name + " has " + data.count.to_s
    
    tcscores = Hash.new()
    tscores = Hash.new()
    dcscores = Hash.new()
    dscores = Hash.new()
    cscores = Hash.new()
    prev = Hash.new()
    prev_token = data.first.session_token
    current_stage = ''
    count = 0
    last_end = nil
    clast_touch = nil
    last_touch = nil
    data.each do |entry|

      if prev[entry.inspect.to_s].nil? 

        if entry.key.include?('TenTouchEvent')

          if tcscores[entry.session_token].nil?
            tcscores[entry.session_token] = Hash.new
          end
          if tcscores[entry.session_token][current_stage].nil?
            tcscores[entry.session_token][current_stage] = Array.new
          end

          if entry.timeSinceLastTouch.to_f < 10.0
            if tcscores[entry.session_token][current_stage].nil?
              tcscores[entry.session_token][current_stage] = Array.new
            end
            tcscores[entry.session_token][current_stage] << entry.timeSinceLastTouch.to_f
          end
        end

        if entry.key.include?('TenTouchEvent')

          if dcscores[entry.session_token].nil?
            dcscores[entry.session_token] = Hash.new
          end
          if dcscores[entry.session_token][current_stage].nil?
            dcscores[entry.session_token][current_stage] = Array.new
          end

          if entry.timeSinceLastTouch.to_f < 10.0
            if dcscores[entry.session_token][current_stage].nil?
              dcscores[entry.session_token][current_stage] = Array.new
            end

            unless clast_touch.nil?
              start_time =  DateTime.strptime(clast_touch, "%m/%d/%Y %H:%M:%S").to_time 
              end_time = DateTime.strptime(entry.timestamp, "%m/%d/%Y %H:%M:%S").to_time 

              dcscores[entry.session_token][current_stage] << (end_time - start_time)
            end
          end
          clast_touch = entry.timestamp
        end


        prev[entry.inspect.to_s] = entry

      end
      
      if entry.key.include?('TenTouchEvent')

        if dscores[entry.session_token].nil?
          dscores[entry.session_token] = Hash.new
        end
        if dscores[entry.session_token][current_stage].nil?
          dscores[entry.session_token][current_stage] = Array.new
        end

        if entry.timeSinceLastTouch.to_f < 10.0
          if dscores[entry.session_token][current_stage].nil?
            dscores[entry.session_token][current_stage] = Array.new
          end

          unless last_touch.nil?
            start_time =  DateTime.strptime(last_touch, "%m/%d/%Y %H:%M:%S").to_time 
            end_time = DateTime.strptime(entry.timestamp, "%m/%d/%Y %H:%M:%S").to_time 

            dscores[entry.session_token][current_stage] << (end_time - start_time)
          end
        end
        last_touch = entry.timestamp
      end



      if entry.key.include?('TenTouchEvent')

        if tscores[entry.session_token].nil?
          tscores[entry.session_token] = Hash.new
        end
        if tscores[entry.session_token][current_stage].nil?
          tscores[entry.session_token][current_stage] = Array.new
        end

        if entry.timeSinceLastTouch.to_f < 10.0
          if tscores[entry.session_token][current_stage].nil?
            tscores[entry.session_token][current_stage] = Array.new
          end
          tscores[entry.session_token][current_stage] << entry.timeSinceLastTouch.to_f
        end
      end


      if entry.key.include?('TenBreathCycleEnd')

        if cscores[entry.session_token].nil?
          cscores[entry.session_token] = Hash.new
        end
        if cscores[entry.session_token][current_stage].nil?
          cscores[entry.session_token][current_stage] = Array.new
        end

        if cscores[entry.session_token][current_stage].nil?
          cscores[entry.session_token][current_stage] = Array.new
        end
        unless last_end.nil?
          start_time =  DateTime.strptime(last_end, "%m/%d/%Y %H:%M:%S").to_time 
          end_time = DateTime.strptime(entry.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
          cscores[entry.session_token][current_stage] << (end_time - start_time) / 5.0
        end
        last_end = entry.timestamp
      end


      if entry.key.include?('TenStageStart')
          current_stage = entry.name + count.to_s
          count = count + 1
          last_end = entry.timestamp
          last_touch = nil
          clast_touch = nil
      end



      unless prev_token.include?(entry.session_token)
        current_stage = ''
        prev_token = entry.session_token
        last_end = nil
      end
    
    end

    puts 'tcscores'
    tcscores.each do |key, value|
      level_m = Array.new
      value.each do |k, v|
        if v.size != 0
          puts mean(v)
          level_m << mean(v)
        end
      end
      tccsv << [play.player_name, key] + level_m
    end

    puts 'tscores'
    tscores.each do |key, value|
      level_m = Array.new
      value.each do |k, v|
        if v.size != 0
          puts mean(v)
          level_m << mean(v)
        end
      end
      tcsv << [play.player_name, key] + level_m
    end

    puts 'dcscores'
    dcscores.each do |key, value|
      level_m = Array.new
      value.each do |k, v|
        if v.size != 0
          puts mean(v)
          level_m << mean(v)
        end
      end
      dccsv << [play.player_name, key] + level_m
    end

    puts 'dscores'
    dscores.each do |key, value|
      level_m = Array.new
      value.each do |k, v|
        if v.size != 0
          puts mean(v)
          level_m << mean(v)
        end
      end
      dcsv << [play.player_name, key] + level_m
    end


    puts 'cscores'
    cscores.each do |key, value|
      level_m = Array.new
      value.each do |k, v|
        if v.size != 0
          puts mean(v)
          level_m << mean(v)
        end
      end
      ccsv << [play.player_name, key] + level_m
    end


  
  
  end
end
