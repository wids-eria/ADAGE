#A class for storing a save game for a game
#tied to an implementation and a user
#user can overwrite the save game but only gets one per
#implementation of the game

class SaveData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :implementation_id, type: Integer
  field :user_id, type: Integer
  
  index user_id: 1
  index implementation_id: 1 
  index created_at: 1

  def user=(user)
    self.user_id = user.id
  end

  def implementation=(implementation)
    self.implementation_id = implementation.id
  end

end
