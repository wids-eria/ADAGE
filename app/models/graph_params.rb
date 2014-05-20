class GraphParams
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :key, :field_name, :app_token, :time_range, :bin, :type, :game_id, :graph_type 

  def initialize(attributes = {})
    self.time_range = 'hour'
    self.graph_type = 'value over time'
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def url_prefix
    if self.graph_type.include?('value over time')
      return '/data/field_values.json?'
    end

    if self.graph_type.include?('session times')
      return '/data/session_times.json?'
    end
    
  end

  def time_options
    ['hour', 'day', 'week', 'month', 'all']
  end 

  def persisted?
    false
  end
end
