class DataGroup

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :series

  def initialize(attributes = {})
    self.series = Array.new
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def add_to_group data_hash, user, type='line', color=nil
    data_series = DataSeries.new(user_id: user.id)
    data_series.player_name = user.player_name
    if color != nil
      data_series.color = color
    end
    data_series.type = type
    data_series.data = data_hash
    self.series << data_series
  end


  def to_chart_js

      chart_js_blob = Hash.new
      datasets = Array.new
      labels = Array.new

      labels = series.map { |hash| hash.data.keys }.flatten
      labels = labels.uniq.sort!

      self.series.each do |data_hash|
        data_series = Array.new
        data_hash.data.each do |key, value|
          data_series[labels.index(key)] = value.to_s.to_i
        end
        datasets << {
        strokeColor: data_hash.color,
        fillColor: "rgba(0,0,0,.1)",
        data: data_series}
      end

      chart_js_blob[:labels] = labels
      chart_js_blob[:datasets] = datasets

      return chart_js_blob


  end

  def to_rickshaw

    rickshaw_blob = Array.new

    puts self.series.inspect
    
    self.series.each do |data_hash|
      series_hash = Hash.new
      data_series = Array.new
      count = 0
      data_hash.data.sort.map do |key, value|
        unless value.is_a? String
            adjusted = value
            if value.is_a? Boolean
              if value
                adjusted = 1
              else
                adjusted = 0
              end
            end

          if data_hash.type.include?('line')
            data_series << {x: key.to_i, y: adjusted.to_f} 
          else
            data_series << {x: count, y: adjusted.to_f} 
          end

          count = count + 1
        end
      end
      series_hash[:data] = data_series
      series_hash[:color] = data_hash.color
      series_hash[:renderer] = data_hash.type
      series_hash[:name] = data_hash.player_name
      rickshaw_blob << series_hash

    end
    
    return rickshaw_blob
  end

  def to_csv
    labels = series.map { |hash| hash.data.keys }.flatten
    labels = labels.uniq.sort!

    out = CSV.generate do |csv|
      csv << ['player_name', 'player_id'] + labels
      series.each do |s|
        data_series = Array.new
        s.data.each do |key,value|
          data_series[labels.index(key)] = value
        end
        csv << [s.player_name, s.user_id.to_s] + data_series
      end
    end

    return out
  end


end

