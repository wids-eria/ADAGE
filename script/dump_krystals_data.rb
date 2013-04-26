require 'csv'
require 'progressbar'

players=User.all.select{|u| u.data.where(gameName: 'KrystalsOfKaydor').count > 0 }
#players = User.where(player_name: 'TM1')
puts 'total players ' + players.count.to_s
#grab all the column headers
types = AdaData.where(gameName: 'KrystalsOfKaydor').distinct(:key)
types.delete('KoKPlayerMovement') #for now exclude player movement.
puts types.inspect
examples = Array.new
bar = ProgressBar.new 'gathering types', types.count
types.each do |type|
  ex = AdaData.where(key: type, schema: 'DEVELOPMENT-01-28-2013').first
  if ex != nil
    examples << ex
  end
  bar.inc
end
bar.finish
puts examples.count
puts examples.inspect
all_attrs = Array.new
bar = ProgressBar.new 'gathering attributes', examples.count
examples.each do |e|
  e.attributes.keys.each do |k|
    all_attrs << k
  end
  bar.inc
end
bar.finish
puts all_attrs.inspect

#bar = ProgressBar.new 'parsing players', players.count
players.each do |play|
  data = play.data.where(gameName: 'KrystalsOfKaydor').where(schema: 'DEVELOPMENT-01-28-2013')
  if data.count > 0
    CSV.open("csv/krystals/krystals_test_"+play.email+".csv", "w") do |csv|
      puts play.email
      puts data.count
      keys = Hash.new
      data.each do |log_entry|
        unless log_entry.key.include?('KoKPlayerMovement')
          if keys[log_entry.key] != nil
            keys[log_entry.key] << log_entry
          else
            keys[log_entry.key] = Array.new
            keys[log_entry.key] << log_entry
          end
        end
      end
     
      puts all_attrs.uniq 
      csv << all_attrs.uniq
      keys.values.each do |entries|
        entries.each do |entry|
          out = Array.new
          all_attrs.uniq.each do |attr|
            if entry.attributes.keys.include?(attr)
              out << entry.attributes[attr]
            else
              out << ""
            end
          end
          csv << out
        end
      end
    end
  end
 # bar.inc
end
#bar.finish