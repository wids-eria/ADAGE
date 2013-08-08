class ParticipantRole < Role
  belongs_to :game

  attr_accessible :name, :game, :type, :users

  has_many :assignments
end
