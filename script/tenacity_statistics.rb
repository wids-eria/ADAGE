require 'csv'

class Tplayer
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def run csv

    minds = user.data.where(gameName: 'Tenacity-Meditation').without([:_id, :created_at, :updated_at]).asc(:timestamp)
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
    


    if minds.count > 0
      sessions = minds.distinct(:session_token)
      total_sessions = sessions.count
      sessions.each do |token|
        session_logs = minds.where(session_token: token)
        end_time =  DateTime.strptime(session_logs.last.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        start_time = DateTime.strptime(session_logs.first.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        session_times[start_time.to_s] = ((end_time - start_time)/1.minute).round 
        total_playtime = total_playtime + session_times[start_time.to_s]
      end

      starts = minds.where(key: 'TenStageStart')
      last_name = ''
      starts.each do |start|
        unless last_name.include?(start.name)
          level_starts = level_starts + 1
          last_name = start.name
        end
      end
      completes = minds.where(key: 'TenStageComplete').asc(:timestamp)
      last_name = ''
      completes.each do |comp|
        unless last_name.include?(comp.name)
            level_list << comp.name
            level_completes = level_completes + 1
            last_name = comp.name
        end
      end

      breaths = minds.where(key: 'TenBreathCycleEnd')
      total_cycles = breaths.count
      total_success = breaths.where(success: true).count
      total_fail = breaths.where(success: false).count

      scores = minds.where(key: 'TenSelfAssessment')
      scores.each do |log|
        self_assessments << log.selfAssessmentValue
      end 


      csv << [user.player_name, total_sessions.to_s, total_playtime.to_s, level_starts.to_s, level_completes.to_s, level_list.to_s, total_cycles.to_s, total_success.to_s, total_fail.to_s, self_assessments.to_s]

      




    end



  end

end


class TenacityPlayerStats

  def run player_list
    csv = CSV.open("csv/tenacity/mindfulness_player_totals.csv", "w")

    csv << ['player id', 'session count', 'total session time', 'levels started', 'levels completed', 'levels played in order', 'total breath cycles', 'total successful cycles', 'total unsuccessful cycles', 'self assessment values in timesequence order']

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

players = CSV.open("csv/tenacity/mindfulness_players.csv", 'r')
TenacityPlayerStats.new.run players
