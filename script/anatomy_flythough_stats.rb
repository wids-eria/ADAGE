require 'csv'
require 'progressbar'
require 'json'

class ProccessedPlayerStats
  attr_accessor :player_name, :play_time, :distance

  def initialize(name, time, dist)
    self.player_name = name
    self.play_time = time
    self.distance = dist
  end
end

class FlythroughStatistics
  def run

    #Get players with Anatomy Browser Data
    ids = AdaData.where(gameName: 'APA:Tracts').distinct(:user_id)
    players = User.where(id: ids) 
    puts players.count
    bar = ProgressBar.new 'players', players.count
    stats = Array.new
    jfile = File.open('csv/flythrough_stats.json', 'w')
    csv = CSV.open('csv/flythrough_stats.csv', 'w')
    csv << ['player name', 'total playtime', 'distance', 'no rot'] # 'end x', 'end y', 'end z', 'end rotx' 'end roty', 'end rotz']
    zero_playtime = 0
    zero_rot = 0
    zero_move = 0
    zero_move_rot = 0
    total_fly = 0
    players.each do |player|
      fly_data = player.data.where(gameName: 'APA:Tracts', key: 'Colon Position')
      both = 0
      if fly_data.count > 0
        total_fly = total_fly + 1
        start_time = fly_data.first.timestamp
        first_session_token = fly_data.first.session_token
        end_time = fly_data.where(session_token: first_session_token).last.timestamp
        first = fly_data.first
        last = fly_data.where(session_token: first_session_token).last
        total = end_time - start_time
        no_rot = false
        no_playtime = false
        no_move_or_rot = false
        if total == 0
          no_playtime = true
          zero_playtime = zero_playtime + 1
        end
        if fly_data.first.z == fly_data.last.z
          zero_move = zero_move + 1
          both = both + 1
        end
        if fly_data.first.rotz == fly_data.last.rotz
          zero_rot = zero_rot + 1
          both = both + 1
          no_rot = true
        end
        if both == 2
          no_move_or_rot = true
          zero_move_rot = zero_move_rot + 1
        end
        distance = calculate_distance(last.x, last.y, last.z, first.x, first.y, first.z)
        stats << ProccessedPlayerStats.new(player.player_name, total, distance)
        unless no_move_or_rot or no_playtime
          csv << [player.player_name, total.to_s, distance, no_rot ] #, last.x, last.y, last.z, last.rotx, last.roty, last.rotz]
        end
      end
      bar.inc
    end
    jfile.write(JSON.pretty_generate(stats))
    jfile.close
    bar.finish
    puts 'total player count ' + players.count.to_s
    puts 'total with fly data ' + total_fly.to_s
    puts 'zero playtime ' + zero_playtime.to_s
    puts 'zero movement ' + zero_move.to_s
    puts 'zero rotation ' + zero_rot.to_s
    puts 'zero rot and move ' + zero_move_rot.to_s
    csv.close
    
  end

  def calculate_distance x1, y1, z1, x2, y2, z2
    x = x2-x1
    y = y2-y1
    z = z2-z1

    sum = x**2 + y**2 + z**2
    distance = Math.sqrt(sum)
    return distance

  end
end

FlythroughStatistics.new.run
