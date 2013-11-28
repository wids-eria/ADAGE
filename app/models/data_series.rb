class DataSeries
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :data, :player_name, :user_id

  def initialize(attributes = {})
    self.data = Array.new
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


end
