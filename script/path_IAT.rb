require 'csv'

players=User.all

CSV.open("csv/fairplay/fairplay_IAT.csv", "w") do |csv|
  csv << ['player name', 'auth token', 'final bias', 'control group'] + ['delta times']*4 +  ['standard deviations']*2
  players.each do |play|
    data = play.data.where(gameName: 'FairPlay', schema: '12-14-2012 Belinda Data 1')
    if data.count > 0
      puts play.player_name
      final_bias = data.where(key: 'IATFinalBias').first
      if final_bias != nil
        delta_times = data.where(key: 'IATDeltaTimes').limit(4).map{ |x| x.deltaTime }
        puts delta_times.count
        std_devs = data.where(key: 'IATStandardDeviations').limit(2).map{ |x| x.deviation }
        puts std_devs.count
      
        padding = ['']*(20 - delta_times.count)

        csv << [play.player_name, play.authentication_token, final_bias.bias, play.control_group] + delta_times + std_devs      
      end

    end
  end
end
