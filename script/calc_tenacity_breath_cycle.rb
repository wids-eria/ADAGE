require 'csv'

def mean(array)
  array.inject(0) { |sum, x| sum += x } / array.size.to_f
end

def mean_and_standard_deviation(array)
  m = mean(array)
  variance = array.inject(0) { |variance, x| variance += (x - m) ** 2 }
  return [m, Math.sqrt(variance/(array.size-1))]
end


ids = AdaData.with_game('Tenacity-Meditation').only(:user_id).distinct(:user_id)
players = User.where(id: ids)

players.each do |play|
  data = play.data('Tenacity-Meditation').in(key: ['TenTouchEvent', 'TenStageStart'] ).asc(:timestamp)
  if data.count > 0
    
    CSV.open("csv/tenacity/average_breath_"+play.email+".csv", "w") do |csv|

      csv << ['name', 'session', 'scores'] 

      puts play.player_name + " has " + data.count.to_s
      
      scores = Hash.new()
      last_time = ''
      prev_token = data.first.session_token
      current_stage = ''
      count = 0
      data.each do |entry|

        unless last_time.include?('TenTouchEvent')

          if entry.key.include?('TenTouchEvent')

            if scores[entry.session_token].nil?
              scores[entry.session_token] = Hash.new
            end
            if scores[entry.session_token][current_stage].nil?
              scores[entry.session_token][current_stage] = Array.new
            end

            if entry.timeSinceLastTouch.to_f < 10.0
              if scores[entry.session_token][current_stage].nil?
                scores[entry.session_token][current_stage] = Array.new
              end
              scores[entry.session_token][current_stage] << entry.timeSinceLastTouch.to_f
            end
          end

          if entry.key.include?('TenStageStart')
              current_stage = entry.name + count.to_s
              count = count + 1
          end

          last_time = entry.timestamp

        end

        unless prev_token.include?(entry.session_token)
          last_time = ''
          current_stage = ''
          prev_token = entry.session_token
        end
      
      end

      all_values = Array.new
      scores.each do |key, value|
        level_m = Array.new
        value.each do |k, v|
          if v.size != 0
            puts mean(v)
            level_m << mean(v)
          end
        end
        csv << [play.player_name, key] + level_m
      end

    
    end
  
  end
end
