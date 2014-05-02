require 'csv'

def logs_equal(prev, entry)

  if prev.nil?
    return false
  end
  
  if prev.key == entry.key

    prev.attributes.keys.each do |k|
      if prev.attributes[k] != entry.attributes[k]
        return false
      end  
    end

    puts 'found duplicate logs'
    puts 'prev ' + prev.to_s
    puts 'entry ' + entry.to_s
    return true

  end

  return false


end

player_list = CSV.open("csv/tenacity/player_list.csv", 'r')
players = Array.new
player_list.each do |player_name|
  player = User.where(player_name: player_name).first
  if player != nil
    players << player
  end
end

players.each do |play|
  data = play.data('Tenacity-Meditation').without([:_id, :created_at, :updated_at])
  if data.count > 0
    types = play.data('Tenacity-Meditation').distinct(:key)
    puts types.inspect
    examples = Array.new
    types.each do |type|
      ex = play.data('Tenacity-Meditation').where( key: type).first
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


    CSV.open("csv/tenacity/tenacity_"+play.email+"_cleaned.csv", "w") do |csv|
      
      csv << all_attrs.uniq
      prev = nil
      data.each do |entry|
        

        unless logs_equal(prev, entry)
          out = Array.new
          all_attrs.uniq.each do |attr|
            if entry.attributes.keys.include?(attr)
              out << entry.attributes[attr]
            else
              out << ""
            end
          end
          csv << out
          prev = entry
        end


      end
    end
  end
end
