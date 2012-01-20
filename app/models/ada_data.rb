class AdaData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :game, type: String
end
