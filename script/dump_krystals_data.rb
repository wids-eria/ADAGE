require 'csv'

player_list = CSV.open("csv/tenacity/crystals_players.csv", 'r')
players = Array.new
player_list.each do |player_name|
  player = User.where(player_name: player_name).first
  if player != nil
    players << player
  end
end


players.each do |play|
  data = play.data.where(gameName: 'KrystalsOfKaydor').asc(:timestamp)
  if data.count > 0
    types = data.distinct(:key)
    types.delete('KoKPlayerMovement') #for now exclude player movement.
    puts types.inspect
    examples = Array.new
    types.each do |type|
      ex = data.where(key: type).first
      if ex != nil
        examples << ex
      end
    end
    puts examples.count
    puts examples.inspect
    all_attrs = Array.new
    examples.each do |e|
      e.attributes.keys.each do |k|
        all_attrs << k
      end
    end
    puts all_attrs.inspect


    CSV.open("csv/tenacity/crystals_"+play.email+".csv", "w") do |csv|
      #puts play.email
      #puts data.count
     
      #puts all_attrs.uniq 
      csv << all_attrs.uniq
      data.each do |entry|
        unless entry.key.include?('KoKPlayerMovement')
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
end
