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

  def add_to_group data_hash, user
    data_series = DataSeries.new
    data_series.player_name = user.player_name
    data_series.user_id = user.id
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
          data_series[labels.index(key)] = value
        end
        datasets << {
        fillColor: "rgba(" + (rand.rand(0...220)).to_s + ", 220,"  + (rand.rand(0...220)).to_s +  ",0.5)",
        strokeColor: "rgba(220,220,220,1)",
        data: data_series}
      end

      chart_js_blob[:labels] = labels
      chart_js_blob[:datasets] = datasets

      return chart_js_blob


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

