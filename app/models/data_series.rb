class DataSeries
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :data, :player_name, :id, :color, :type

  def initialize(attributes = {})
    rand = Random.new(attributes[:id])
    self.data = Array.new
    self.color = "rgba(" + (rand.rand(0...220)).to_s + ", 220, "  + (rand.rand(0...220)).to_s +  ",1.0)"
    self.type = 'line'
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


end
