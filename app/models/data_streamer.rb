class DataStreamer
  attr_accessor :data

  def initialize(data)
    self.data = data
  end

  def each
    self.data.each do |row|
      yield row.to_json
    end
  end
end
