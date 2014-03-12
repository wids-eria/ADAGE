require 'csv'




all_data = AdaData.where(gameName: 'kodu')
versions = all_data.distinct(:schema)
puts versions

versions.each do |v|
  data = all_data.where(schema: v)
  if data.count > 0
    types = data.distinct(:key)
    puts types.inspect
    examples = Array.new
    types.each do |type|
      ex = data.where(key: type).first
      if ex != nil
        examples << ex
      end
    end
    all_attrs = Array.new
    examples.each do |e|
      e.attributes.keys.each do |k|
        all_attrs << k
      end
    end


    CSV.open("csv/kodu/"+v+"_data.csv", "w") do |csv|
      
      csv << all_attrs.uniq
      data.each do |entry|
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
