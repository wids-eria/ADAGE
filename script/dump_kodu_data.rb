require 'csv'

player = User.where(email: 'player@example.com').first
data = player.data.all
CSV.open("kodu_test_data.csv", "w") do |csv|
  csv << ['created at', 'timestamp', 'tag name', 'data']
  data.each do |log_entry|
    csv << [log_entry.created_at, log_entry.time, log_entry.name, log_entry.data]
  end
end
