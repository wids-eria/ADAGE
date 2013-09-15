require 'json'

data = AdaData.where(gameName: 'KrystalsOfKaydor').asc(:created_at)
data = data.where(schema: 'PRODUCTION-05-29-2013')
data = data.where(key: 'KoKHealthChange')
data = data.where(:score.lt => 0)
puts data.count
data.each do |foo|
  puts foo.score
end
if data.count > 0
  jfile = File.open('csv/crystals/json/healthchange.json', 'w')
  jfile.write(data.asc(:timestamp).to_json)
  jfile.close
end

