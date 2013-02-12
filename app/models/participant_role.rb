class ParticipantRole < Role
  belongs_to :game

  has_many :users, :through => :roles_users
  attr_accessible :name, :game, :type

end
