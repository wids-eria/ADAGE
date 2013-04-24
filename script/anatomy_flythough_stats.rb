require 'csv'
require 'progressbar'
require 'json'

class ProccessedPlayerStats
  attr_accessor :player, :player_name, :play_time, :distance, :no_rot, :no_move, :data, :collisions, :fly_data

  def initialize(player)
    self.player = player
    self.player_name = player.player_name
    self.data =  player.data.where(gameName: 'APA:Tracts')
    self.no_rot = false
    self.no_move = false
    self.play_time = 0
    self.distance = 0
    self.collisions = Array.new
   end

  def crunch_numbers
    self.fly_data = data.where(key: 'Colon Position')
    if fly_data.count > 0
      first = fly_data.first
      first_session_token = first.session_token
      first_session_data = fly_data.where(session_token: first_session_token)
      last = first_session_data.last
      collisions = data.where(key: 'Colon Collision', session_token: first_session_token)
      self.play_time = last.timestamp - first.timestamp
      self.distance =  calculate_distance(last.x, last.y, last.z, first.x, first.y, first.z)
      #(1...first_session_data.count).each do |index|
      #  i = fly_data[index]
      #  j = fly_data[index-1]
      #  self.distance = self.distance + calculate_distance(i.x, i.y, i.z, j.x, j.y, j.z)
      #end

      if first.rotx == last.rotx and first.rotz == last.rotz and first.roty = last.roty
        self.no_rot = true
      end
      if first.x == last.x and first.z == last.z and first.y = last.y
       self.no_move = true
      end

      collisions.each do |collide|
        self.collisions << collide.collidedWith
      end

    end

  end

  def output_json
    data = player.data.where(gameName: 'APA:Tracts')
    if data.count > 0
      jfile = File.open('csv/flythrough/'+player_name+'.json', 'w')
       jfile.write(data.to_json)
      jfile.close
    end
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

class FlythroughStatistics
  def run

    #Get players with Anatomy Browser Data
    ids = AdaData.where(gameName: 'APA:Tracts').distinct(:user_id)
    players = User.where(id: ids) 
    puts players.count
    bar = ProgressBar.new 'players', players.count
    csv = CSV.open('csv/flythrough/flythrough_stats.csv', 'w')
    csv << ['player name', 'total playtime', 'distance', 'no rot', 'no move']     
    zero_rot = 0
    zero_move = 0
    zero_move_rot = 0
    zero_playtime = 0
    total_fly = 0
    players.each do |player|
      pps = ProccessedPlayerStats.new(player)
      pps.crunch_numbers
      #pps.output_json
      if pps.fly_data != nil
          total_fly = total_fly+1
          
          if pps.play_time == 0
            zero_playtime = zero_playtime+1
          end

          if pps.no_rot
            zero_rot = zero_rot+1
          end

          if pps.no_move
            zero_move = zero_move+1
          end

          if pps.no_rot and pps.no_move
            zero_move_rot = zero_move_rot+1
          end

          unless pps.no_move and pps.no_rot or pps.play_time == 0
            csv << [pps.player_name, pps.play_time.to_s, pps.distance, pps.no_rot, pps.no_move] + pps.collisions
          end


      end
      bar.inc
    end
    bar.finish
    puts 'total player count ' + players.count.to_s
    puts 'total with fly data ' + total_fly.to_s
    puts 'zero playtime ' + zero_playtime.to_s
    puts 'zero movement ' + zero_move.to_s
    puts 'zero rotation ' + zero_rot.to_s
    puts 'zero rot and move ' + zero_move_rot.to_s
    csv.close
    
  end

end

FlythroughStatistics.new.run
