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
  data = play.data('Tenacity-Meditation').where(key: 'TenSelfAssessment' ).asc(:timestamp)
  if data.count > 0
    
    CSV.open("csv/tenacity/assessment_delta_"+play.email+".csv", "w") do |csv|

      csv << ['name', 'session', 'scores'] 

      puts play.player_name + " has " + data.count.to_s
      
      scores = Hash.new()
      pre = true
      last = 0 
      last_time = ''
      prev_token = data.first.session_token
      data.each do |entry|

        unless last_time.include?(entry.timestamp)

          if pre == true
            pre = false
          else
            if scores[entry.session_token].nil?
              scores[entry.session_token] = Array.new
            end
            scores[entry.session_token] << last - entry.selfAssessmentValue
          end

          last = entry.selfAssessmentValue
          last_time = entry.timestamp

        end

        unless prev_token.include?(entry.session_token)
          pre = true
          last = 0
          last_time = ''
          prev_token = entry.session_token
        end
      
      end

      all_values = Array.new
      scores.each do |key, value|
        puts key
        puts value
        csv << [play.player_name, key] + value
        all_values = all_values + value
      end

      csv << []
      csv << mean_and_standard_deviation(all_values)
    
    end
  
  end
end
