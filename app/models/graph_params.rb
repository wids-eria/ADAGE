class GraphParams
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :key, :field_name, :app_token, :time_range, :bin, :type, :game_id 

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def time_options
    ['hour', 'day', 'week', 'month', 'all']
  end 

  def persisted?
    false
  end
end
