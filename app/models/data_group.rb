class DataGroup
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :datasets, :labels, :rand

  def initialize(attributes = {})
    self.datasets = Array.new
    self.labels = Array.new
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def chart_js_add_to_data_group data_hash

      data_series = DataSeries.new
      data_hash.each do |key, value|
          if self.labels.include?(key)
              data_series.data.insert(self.labels.index(key), value)
          else
              self.labels << key
              data_series.data << value
          end
      end

      self.rand = Random.new(data_series.data.first.to_i)
      self.datasets << {
			fillColor: "rgba(" + rand.rand(0...255).to_s + ", 220," + rand.rand(0...255).to_s + ",0.5)",
			strokeColor: "rgba(220,220,220,1)",
      data: data_series.data}

  end

end

