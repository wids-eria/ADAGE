require 'csv'

class Tplayer
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def run csv

    minds = user.data('KrystalsOfKaydor').asc(:timestamp)
    total_sessions = 0
    total_playtime = 0
    session_times = Hash.new
    level_starts = 0
    level_completes = 0
    level_list = Array.new
    total_cycles = 0
    total_success = 0
    total_fail = 0
    self_assessments = Array.new
    objective_starts = 0
    objective_completes = 0
    objective_list = Array.new

    


    if minds.count > 0
      sessions = user.data('KrystalsOfKaydor').distinct(:session_token)
      total_sessions = sessions.count
      sessions.each do |token|
        session_logs = user.data('KrystalsOfKaydor').where(session_token: token).asc(:timestamp)
        end_time =  DateTime.strptime(session_logs.last.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        start_time = DateTime.strptime(session_logs.first.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        session_times[start_time.to_s] = ((end_time - start_time)/1.minute).round 
        total_playtime = total_playtime + session_times[start_time.to_s]
      end



      quests = minds.where(:key.in => ['KoKQuestStart', 'KoKQuestEnd']).asc(:timestamp)
      puts quests.count
      quest_stack = Array.new
      quests.each do |q|
        if q.key.include?('KoKQuestStart')
          unless quest_stack.include?(q.name)
            quest_stack << q.name
            level_starts = level_starts + 1
          end
        else
          if quest_stack.include?(q.name)
            level_completes = level_completes + 1
            quest_stack = quest_stack.delete(q.name)
            level_list << q.name
          end
        end
      end

      objectives = minds.where(:key.in => ['KoKObjectiveStart', 'KoKObjectiveEnd']).asc(:timestamp)  
      puts objectives.count
      objective_stack = Array.new
      objectives.each do |q|
        if q.key.include?('KoKObjectiveStart')
          unless objective_stack.include?(q.name)
            objective_stack << q.name
            objective_starts = objective_starts + 1
          end
        else
          if objective_stack.include?(q.name)
            objective_completes = objective_completes + 1
            objective_stack = objective_stack.delete(q.name)
            objective_list << q.name
          end
        end
      end


      csv << [user.player_name, total_sessions.to_s, total_playtime.to_s, level_starts.to_s, level_completes.to_s, level_list.to_s, objective_starts.to_s, objective_completes.to_s, objective_list.to_s]

      




    end



  end

end


class TenacityPlayerStats

  def run player_list
    csv = CSV.open("csv/tenacity/crystals_player_totals.csv", "w")

    csv << ['player id', 'session count', 'total session time', 'quest started', 'quest completed', 'quests completed in order', 'objectives started', 'objectives completed', 'objectives completed in order']

    player_list.each do |player_name|
      player = User.where(player_name: player_name).first
      if player != nil
        Tplayer.new(player).run csv
      else
        puts player_name.to_s + " NOT FOUND"
      end
    end
    csv.close
  end

end

players = CSV.open("csv/tenacity/crystals_players.csv", 'r')
TenacityPlayerStats.new.run players
