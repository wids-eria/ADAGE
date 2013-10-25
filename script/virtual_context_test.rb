require 'json'
require 'csv'

data = AdaData.where(ADAversion: 'bodacious_bonobo')

data = data.where(gameName: 'KrystalsOfKaydor')
data = data.where(schema: 'PRODUCTION-05-29-2013')

contexts = data.where(ada_base_type: ['ADAStartUnit', 'ADAEndUnit'])
c_names = contexts.distinct(:name)
players = contexts.distinct(:user_id)
total_starts = Hash.new(0)
total_ends = Hash.new(0)
c_names.each do |name|
  total_starts[name] = 0
  total_ends[name] = 0
end


players.each do |id|

  player_data = contexts.where(user_id: id).asc(:timestamp)
  player_total_starts = 0
  player_total_finish = 0
  p_contexts = Hash.new
  player_data.each do |log|

    if log.ada_base_type == 'ADAStartUnit'

      total_starts[log.name] = total_starts[log.name] + 1
    
    
    else

      total_ends[log.name] = total_ends[log.name] + 1
    
    
    end


  end


end

puts total_starts.inspect
puts total_ends.inspect

