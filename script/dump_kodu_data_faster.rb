require 'csv'

players=User.where(id: 3454..3456)
CSV.open("kodu_cfk_test.csv", "w") do |csv|
  csv << ['player name', 'created at', 'timestamp', 'tag name', 'data']
  players.each do |play|
    data = play.data.where(gameName: 'kodu').where(name: 'SetGameMode')
    puts data.count
    data.each do |log_entry|
      csv << [play.email, log_entry.created_at, log_entry.time, log_entry.name, log_entry.data]
    end
  end
end
