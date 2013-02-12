require 'csv'

players=User.all

CSV.open("fairplay_IAT.csv", "w") do |csv|
  csv << ['player name', 'auth token', 'final bias', 'control group']
  players.each do |play|
    data = play.data.where(gameName: 'FairPlay')
    if data.count > 0
      data.each do |log_entry|
        if log_entry.key == 'IATFinalBias'
          puts play.player_name + " " + play.authentication_token + " " + log_entry.bias.to_s + " " + play.control_group.to_s
          csv << [play.player_name, play.authentication_token, log_entry.bias.to_s, play.control_group.to_s]
        end
      end
      
    end
  end
end
