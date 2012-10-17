require 'csv'

players=User.all

CSV.open("tenacity_data_demo.csv", "w") do |csv|
  level_log = Hash.new
  level_log['player'] = ''
  level_log['level'] = ''
  level_log['duration'] = ''
  level_log['breaths'] = ''
  level_log['total time'] = ''
  level_log['pre assessment'] = ''
  level_log['post assessment'] = ''
  csv << level_log.keys
  players.each do |play|
    data = play.data.where(gameName: 'Tenacity-Meditation').where(schema: 'BETA-TESTING')
    if data.count > 0
      puts data.count
      deltas = Array.new
      previous_time = nil
      #puts 'id ' + play.id.to_s 
      data.each do |log_entry|
      
        case log_entry.key
        when 'PlayerSelect'
         level_log['player'] = log_entry.selectedPlayerName
        when 'SelfAssessment'
         if log_entry.isPrePost.include?('Pre')
          level_log['pre assessment'] = log_entry.selfAssessmentValue
         else
          level_log['post assessment'] = log_entry.selfAssessmentValue
         end
        when 'StageStart'
          level_log['level'] = log_entry.stageName
          if log_entry.respond_to?('breathsPerCycle')
            level_log['breaths'] = log_entry.breathsPerCycle
          end
          if log_entry.respond_to?('sessionTime')
            level_log['duration'] = log_entry.sessionTime
          end
        when 'TouchEvent'
          if previous_time.present?
            time = log_entry.timestamp - previous_time
            #puts log_entry.timestamp
            if log_entry.touchType.include?('InvalidTouch')
              #deltas << '-' + log_entry.timeSinceLastTouch
              deltas << -time
            else
              deltas << time
            end
          end
          previous_time = log_entry.timestamp
        when 'StagePackage'
          #do something with giant string
        when 'LevelComplete'
          level_log['total time'] = log_entry.timeInLevel
          csv << level_log.values + deltas
        end

      end 
      
      csv << level_log.values + deltas
    end
  end
end

