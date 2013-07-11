require 'csv'
require 'progressbar'

#players=User.all
players=User.where(consented: 'true')
=begin
CSV.open("kodu_moving_minds_data.csv", "w") do |csv|
  csv << ['player name', 'created at', 'timestamp', 'tag name', 'data']
  puts players.count
  players.each do |play|
    data = play.data.where(gameName: 'kodu')
    puts data.count
    data.each do |log_entry|
      csv << [play.email, log_entry.created_at, log_entry.time, log_entry.name, log_entry.data]
    end
  end
end
=end


CSV.open("kodu_1_18_2013.csv", "w") do |csv|
  csv << ['player name', 'created at', 'timestamp', 'tag name', 'data']
  puts players.count
  players.each do |p|
    data = p.data.where(gameName: 'kodu')
    puts data.count
    bar = ProgressBar.new 'wee', data.count 
    data.each do |log_entry|
      csv << [p.email, log_entry.created_at, log_entry.time, log_entry.name, log_entry.data]
      bar.inc
    end
  end
    bar.finish
end
