class AdaData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :game, type: String
  field :user_id, type: Integer

  index :user_id
  index :gameName
  index :created_at
  index :name
  index key: 1, schema: 1

  def user=(user)
    self.user_id = user.id
  end

  def user
    User.find(self.user_id)
  end

end
