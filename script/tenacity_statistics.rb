require 'csv'

class Tplayer
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def run csv_totals, csv_levels, csv_breath_cycles, level_keys, length_keys

    total_sessions = 0
    total_playtime = 0
    total_time_in_level = 0
    session_times = Hash.new
    level_starts = 0
    level_completes = 0
   
    level_start_list = Hash.new
    level_complete_list = Hash.new
    level_keys.each do |k|
      level_start_list[k] = 0
      level_complete_list[k] = 0
    end
   
    length_start_list = Hash.new
    length_complete_list = Hash.new
    length_keys.each do |k|
      length_start_list[k] = 0
      length_complete_list[k] = 0
    end
   
    total_cycles = 0
    total_success = 0
    total_fail = 0
    level_success = 0
    level_fail = 0
    self_assessments = Array.new
    pre = 0
    post = 0
    


    sessions =  AdaData.with_game('Tenacity-Meditation').asc(:timestamp).distinct(:session_token)
    total_sessions = sessions.count
    sessions.each do |token|
      session_logs = AdaData.with_game('Tenacity-Meditation').where(session_token: token).asc(:timestamp)
      end_time =  DateTime.strptime(session_logs.last.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
      start_time = DateTime.strptime(session_logs.first.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
      session_times[start_time.to_s] = (end_time - start_time) 
      total_playtime = total_playtime + session_times[start_time.to_s]
    end

    logs = AdaData.with_game('Tenacity-Meditation').where(:key.in => ['TenStageStart', 'TenStageComplete', 'TenBreathCycleEnd', 'TenSelfAssessment'])
    last_name = ''
    last_time = 0
    started = false
    logs.each do |log|
      if log.key.include?('TenStageStart')
        level_starts = level_starts + 1
        level_start_list[log.name] = level_start_list[log.name] + 1
        length_start_list[log.sessionTime] = length_start_list[log.sessionTime] + 1
        last_name = log.name
        last_time = log.sessionTime.to_i * 60 
        started = true
      end

      if log.key.include?('TenStageComplete') and started == true
        level_completes = level_completes + 1
        level_complete_list[log.name] = level_complete_list[log.name] + 1
        length_complete_list[last_time] = length_complete_list[last_time] + 1
        total_time_in_level = total_time_in_level + last_time


        started = false
      end

      if log.key.include?('TenSelfAssessment')
        
        post = log.selfAssessmentValue

        if pre != 0  
          csv_levels << [user.player_name, log.timestamp, log.session_token, log.name, last_time.to_s, total_time_in_level.to_s, pre.to_s, post.to_s, level_success.to_s, level_fail.to_s]
        end
        
        pre = log.selfAssessmentValue

        level_success = 0
        level_fail = 0
      end

      if log.key.include?('TenBreathCycleEnd')
        csv_breath_cycles << log.attributes.values
        total_cycles = total_cycles + 1
        if log.success == true
          total_success = total_success + 1
          level_success = level_success + 1
        else
          total_fail = total_fail + 1
          level_fail = level_fail + 1
        end
      end



    end
    

    
    csv_totals << [user.player_name, total_sessions.to_s, total_playtime.to_s, total_playetime/total_sessions, total_time_in_level.to_s, level_starts.to_s, level_completes.to_s, total_cycles.to_s, total_success.to_s, total_success/total_cycles, total_fail.to_s] + level_start_list.values + level_complete_list.values + length_start_list.values + length_complete_list.values

      







  end

end


class TenacityPlayerStats

  def run player_list
    csv_totals = CSV.open("csv/tenacity/tenacity_player_totals.csv", "w")
    csv_levels = CSV.open("csv/tenacity/tenacity_per_level_totals.csv", "w")
    csv_breath_cycles = CSV.open("csv/tenacity/tenacity_breath_cycles.csv", "w")

    level_keys = AdaData.with_game('Tenacity-Meditation').where(key: 'TenStageStart').distinct(:name)
    length_keys = AdaData.with_game('Tenacity-Meditation').where(key: 'TenStageStart').distinct(:sessionTime)

    breath_cycle_col = AdaData.with_game('Tenacity-Meditation').where(key: 'TenBreathCycleEnd').last

    csv_breath_cycles << breath_cycle_col.attributes.keys

    csv_level << ['player', 'timestamp', 'session token', 'level name', 'selected session time', 'time in level', 'pre', 'post', 'success count', 'failure count']
    
    level_s = level_keys.map{ |k| k + ' starts'}
    level_c = level_keys.map{ |k| k + ' completes'}
    len_s = length_keys.map{ |k| k + ' starts'}
    len_c = length_keys.map{ |k| k + ' completes'}

    csv_totals << ['player id', 'session count', 'total session time', 'average session length', 'total time in level', 'levels started', 'levels completed', 'total breath cycles', 'total successful cycles', 'success %', 'total unsuccessful cycles'] + level_s + level_c + len_s + len_c

    player_list.each do |player_name|
      player = User.where(player_name: player_name).first
      if player != nil
        Tplayer.new(player).run(csv_totals, csv_levels, csv_breath_cycles, level_keys, length_keys)
      else
        puts player_name.to_s + " NOT FOUND"
      end
    end
    csv.close
  end

end

players = CSV.open("csv/tenacity/mindfulness_players.csv", 'r')
TenacityPlayerStats.new.run players
