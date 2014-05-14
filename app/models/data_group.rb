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

  def add_to_group data_hash, user, color="rgba(0,0,0,1)"
    data_series = DataSeries.new
    data_series.player_name = user.player_name
    data_series.user_id = user.id
    data_series.color = color
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
        rand = Random.new(data_hash.user_id)
        data_series = Array.new
        data_hash.data.each do |key, value|
          data_series[labels.index(key)] = value.to_s.to_i
        end
        datasets << {
        strokeColor: "rgba(" + (rand.rand(0...220)).to_s + ", 220,"  + (rand.rand(0...220)).to_s +  ",1.0)",
        fillColor: "rgba(0,0,0,.1)",
        data: data_series}
      end

      chart_js_blob[:labels] = labels
      chart_js_blob[:datasets] = datasets

      return chart_js_blob


  end

  def to_rickshaw

    rickshaw_blob = Array.new
    
    self.series.each do |data_hash|
      series_hash = Hash.new
      data_series = Array.new
      rand = Random.new(data_hash.user_id)
      count = 0
      data_hash.data.keys.sort
      data_hash.data.each do |key, value|
        data_series << {x: key.to_i, y: value} 
        count = count + 1
      end
      series_hash[:data] = data_series
      #series_hash[:color] = data_hash.color
      series_hash[:color] =  "rgba(" + (rand.rand(0...220)).to_s + ", 220,"  + (rand.rand(0...220)).to_s +  ",1.0)"
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

