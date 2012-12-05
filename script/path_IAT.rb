players=User.all
players.each do |play|
  data = play.data.where(gameName: 'Pathfinder')
  if data.count > 0
    data.each do |log_entry|
      if log_entry.key == 'IATFinalBias'
        puts play.player_name + " " + play.authentication_token + " " + log_entry.bias.to_s + " " + play.control_group.to_s
      end
    end
    
  end
end
