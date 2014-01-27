class GameVersionData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :implementation_id, type: Integer
  field :game_id, type: Integer

  
  index implementation_id: 1 
  index created_at: 1

  def game=(game)
    self.game_id = game.id
  end

  def implementation=(implementation)
    self.implementation_id = implementation.id
  end

end
