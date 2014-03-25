#A class for storing a config file for game
#tied to the implementation of the game

class ConfigData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :implementation_id, type: Integer
  field :game_id, type: Integer
  
  index implementation_id: 1 
  index game_id: 1 
  index created_at: 1

  def implementation=(implementation)
    self.implementation_id = implementation.id
  end

  def game=(game)
    self.game_id = game.id
  end

end
