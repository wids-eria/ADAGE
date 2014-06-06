class GraphParams
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :key, :field_names, :app_token, :time_range, :bin, :type, :game_id, :graph_type 

  def initialize(attributes = {})
    self.time_range = 'hour'
    self.graph_type = 'value over time'
    self.field_names = Array.new
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def to_rickshaw_url

    url = url_prefix + '.json?'
    url = add_params(url)
    url = url + '&rickshaw=true'
    return url

  end

  def to_json_url
    
    url = url_prefix + '.json?'
    url = add_params(url)
    return url


  end

  def to_csv_url

    url = url_prefix + '.csv?'
    url = add_params(url)
    return url


  end

  def url_prefix
    if self.graph_type.include?('value over time')
      return '/data/field_values'
    end

    if self.graph_type.include?('session times')
      return '/data/session_times'
    end

    if self.graph_type.include?('key count')
      return '/data/key_counts'
    end
    
  end

  def time_options
    ['hour', 'day', 'week', 'month', 'all']
  end 

  def persisted?
    false
  end


protected

  def add_params url

    if self.app_token != nil
      url = url + '&app_token=' + self.app_token
    end

    if self.time_range != nil
      url = url + '&time_range=' + self.time_range 
    end

    if self.game_id != nil
      url = url + '&game_id=' + self.game_id
    end

    if self.key != nil
      url = url + '&key=' + self.key 
    end

    if self.field_names != nil
      url = url + '&field_names=' + self.field_names.to_json
    end

    return url


  end

end
