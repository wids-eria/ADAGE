require 'csv'
require 'progressbar'
require 'json'

class ProccessedPlayerStats
  attr_accessor :player, :data

  def initialize(player)
    self.player = player
    self.data =  player.data.where(gameName: 'APA:Tracts').in(key: ['Colon Position', 'Colon Collision']).asc(:created_at)
   end

  def crunch_numbers csvs    
    if self.data.count == 0
      return
    end
    toke = self.data.first.session_token
    self.data = self.data.where(session_token: toke).asc(:timestamp)

        visited = Array.new
    trigger_index = 0
    distance = 0
    first_point = self.data.where(key: 'Colon Position').first
    first_collision = self.data.where(key: 'Colon Collision').first
    if first_collision != nil
      trigger_index = triggers.index(first_collision.collidedWith)
    end
    next_trigger = triggers[trigger_index]
    prev_trigger = triggers[trigger_index]

    last_x = first_point.x
    last_y = first_point.y
    last_z = first_point.z
    start_time = first_point.timestamp
    ignore = false
    #puts player.player_name
    self.data.each do |log|
      
      if log.key == 'Colon Position'
        unless ignore
          distance = distance + calculate_distance(last_x, last_y, last_z, log.x, log.y, log.z)
        end
        last_x = log.x
        last_y = log.y
        last_z = log.z
      end

      if log.key == 'Colon Collision'
        
        #The player left the section so write out the info
        if log.collidedWith == next_trigger
          #The are going forward
          
          #if we haven't hit this trigger before 
          unless visited.include?(log.collidedWith)
            ignore = false
            #puts next_trigger

            if distance == 0
              puts '*'*10
              puts player.player_name
              puts log.collidedWith
              puts visited
              puts self.data.first.inspect
              puts '*'*10
            end

            visited << log.collidedWith
            csvs[trigger_index] << [player.player_name, log.timestamp - start_time, distance, true, false, false] 
          end
          back = trigger_index - 1
          if back < 0
            back = 0
          end
          prev_trigger = triggers[back] 
          trigger_index = trigger_index + 1
          if trigger_index > triggers.count-1
            trigger_index = triggers.count-1
          end
          next_trigger = triggers[trigger_index]
          #puts 'forward'
          #puts 'collide ' + log.collidedWith
          #puts 'prev ' + prev_trigger
          #puts 'next ' + next_trigger
          #puts 'index ' + trigger_index.to_s
          start_time = log.timestamp
          distance = 0
        elsif log.collidedWith == prev_trigger
          #They are back tracking
          
          unless ignore or visited.include?(log.collidedWith)
            csvs[trigger_index] << [player.player_name, log.timestamp - start_time, distance, false, true, false] 
          end
          start_time = log.timestamp
          distance = 0
          trigger_index = trigger_index - 1
          if trigger_index < 0
            trigger_index = 0
          end
          next_trigger = prev_trigger
          prev_trigger = triggers[trigger_index] 
          #puts 'back'
          #puts 'collide ' + log.collidedWith
          #puts 'prev ' + prev_trigger
          #puts 'next ' + next_trigger
          #puts 'index ' + trigger_index.to_s


          ignore = true
        else
          #freak out this data is bogus
          #puts '********WARNING collided with ' + log.collidedWith + ' *********'
          return false
        end
      end
      
    end

    unless ignore 
      csvs[trigger_index] << [player.player_name, self.data.last.timestamp - start_time, distance, false, false, true] 
    end

    return true

  end

  def calculate_distance x1, y1, z1, x2, y2, z2
    x = x2-x1
    y = y2-y1
    z = z2-z1

    distance = x*x + y*y + z*z
    return distance

  end

  def triggers
    [ "esopahgousTrigger", "stomachTrigger", "small_intestineTrigger", "large_intestineTrigger", "anusTrigger"]
  end


end

class FlythroughStatistics
  def triggers
    [ "esopahgousTrigger", "stomachTrigger", "small_intestineTrigger", "large_intestineTrigger", "anusTrigger"]
  end

  def run

    #Get players with Anatomy Browser Data
    ids = AdaData.where(gameName: 'APA:Tracts', schema: '4-3-2012').distinct(:user_id)
    players = User.where(id: ids).limit(1000) 
    puts players.count
    bar = ProgressBar.new 'players', players.count
    csvs = Array.new
    triggers.each do |trigger|
      csv = CSV.open('csv/flythrough/sections/'+trigger+'.csv', 'w')
      csv << ['name', 'time', 'distance', 'forward', 'back', 'quit']
      csvs << csv
    end
    tossed = 0
    players.each do |player|
      pps = ProccessedPlayerStats.new player
      success = pps.crunch_numbers csvs
      unless success 
        tossed = tossed + 1
      end
      bar.inc
    end
    puts 'tossed ' + tossed.to_s
  
    bar.finish
    
  end

end

FlythroughStatistics.new.run
