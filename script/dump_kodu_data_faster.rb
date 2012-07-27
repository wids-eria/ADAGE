require 'csv'

players=User.where(id: 3000..3400)
CSV.open("kodu_moving_minds_data_fast.csv", "w") do |csv|
  csv << ['player name', 'created at', 'timestamp', 'tag name', 'data']
  players.each do |play|
    data = play.data.where(gameName: 'kodu')
    data.each do |log_entry|
      csv << [play.email, log_entry.created_at, log_entry.time, log_entry.name, log_entry.data]
    end
  end
end
