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
        total_playtime = total_playtime + ((end_time - start_time))#session_times[start_time.to_s]
      end

      
      csv << [user.player_name, total_sessions.to_s, total_playtime.to_s]

      




    end



  end

end


class TenacityPlayerStats

  def run player_list
    csv = CSV.open("csv/tenacity/crystals_playtime_totals.csv", "w")

    csv << ['player id', 'session count', 'total session time']

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
