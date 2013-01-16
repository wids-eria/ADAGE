require 'csv'
require 'progressbar'

#players=User.all
players=User.where(id: 3454..3456)
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


CSV.open("kodu_1_14_2013.csv", "w") do |csv|
  csv << ['player name', 'created at', 'timestamp', 'tag name', 'data']
  puts players.count
    data = AdaData.where(gameName: 'kodu', consented: true)
    puts data.count
    bar = ProgressBar.new 'wee', data.count 
    data.each do |log_entry|
      csv << [players.detect{|p| p.id == log_entry.user_id}.email, log_entry.created_at, log_entry.time, log_entry.name, log_entry.data]
      bar.inc
    end
    bar.finish
end
