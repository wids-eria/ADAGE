class SaveData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :implementation_id, type: Integer
  field :user_id, type: Integer
  
  index :user_id
  index :implementation_id 
  index :created_at

  def user=(user)
    self.user_id = user.id
  end

  def implementation=(implementaiton)
    self.implementation_id = implementation.id
  end

end
