require 'csv'

players=User.all
players.each do |play|
  data = play.data.where(gameName: 'Tenacity-Meditation')
  if data.count > 0
    CSV.open("tenacity_test_"+play.email+".csv", "w") do |csv|
      puts data.count
      keys = Hash.new
      data.each do |log_entry|
        if keys[log_entry.key] != nil
          keys[log_entry.key] << log_entry
        else
          keys[log_entry.key] = Array.new
          keys[log_entry.key] << log_entry
        end
      end
      
      keys.values.each do |key|
        csv << JSON.parse(key.first.as_document.to_json).keys
        key.each do |entry|
          csv << JSON.parse(entry.as_document.to_json).values
        end
      end
    end
  end
end
