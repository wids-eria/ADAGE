require 'csv'
require 'progressbar'

class Tplayer
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def run csv

    minds = user.data.where(gameName: 'Tenacity-Meditation')
    crystals = user.data.where(gameName: 'KrystalsOfKaydor')
    timers = user.data.where(gameName: 'App Timer') 

    session_times = Hash.new
    if minds.count > 0
      sessions = minds.distinct(:session_token)
      sessions.each do |token|
        session_logs = minds.where(session_token: token)
        end_time =  DateTime.strptime(session_logs.last.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        start_time = DateTime.strptime(session_logs.first.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        session_times[start_time.to_s] = ((end_time - start_time)/1.minute).round 
      end
      csv << [user.player_name, 'Tenacity', 'session count '+sessions.count.to_s] + session_times.flatten
    end

    session_times.clear
    if crystals.count > 0
      sessions = crystals.distinct(:session_token)
      sessions.each do |token|
        session_logs = crystals.where(session_token: token)
        end_time =  DateTime.strptime(session_logs.last.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        start_time = DateTime.strptime(session_logs.first.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        session_times[start_time.to_s] = ((end_time - start_time)/1.minute).round 
      end
      finish_count = crystals.where(name: 'CompleteAllTheQuests').count
      finish_count = crystals.where(name: 'Do all the quests').count
      csv << [user.player_name, 'Crystals', 'session count '+sessions.count.to_s, 'finished the game: '+finish_count.to_s] + session_times.flatten

    end

    session_times.clear
    if timers.count > 0
      start_time = nil
      end_time = nil
      timers.each do |log|
        if log.key == 'LogStart'
          start_time =  DateTime.strptime(log.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        elsif log.key == 'LogStopNormal'
          end_time =  DateTime.strptime(log.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
          session_times[start_time.to_s] = ((end_time - start_time)/1.minute).round 
        else
          end_time =  DateTime.strptime(log.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
          session_times[start_time.to_s + ' Non Normal completion'] = ((end_time - start_time)/1.minute).round 
        end
      end
      csv << [user.player_name, 'Timer', 'session count '+sessions.count.to_s] + session_times.flatten

    end

  end

end


class TenacityPlayerStats

  def run player_list
    csv = CSV.open("csv/tenacity/player_stats.csv", "w")
    #bar = ProgressBar.new 'parsing players', players_list.count

    player_list.each do |player_name|
      player = User.where(player_name: player_name).first
      if player != nil
        Tplayer.new(player).run csv
      else
        puts player + " NOT FOUND"
      end
      #bar.inc
    end
    csv.close
  end

end

players = CSV.open("csv/tenacity/player_list.csv", 'r')
TenacityPlayerStats.new.run players
