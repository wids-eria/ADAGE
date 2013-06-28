class ParticipantRole < Role
  belongs_to :game

  attr_accessible :name, :game, :type, :user_ids

    
  has_many :users, :through => :assignments
end
