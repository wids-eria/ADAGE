class ParticipantRole < Role
  belongs_to :game

  attr_accessible :name, :game, :type, :user_ids
end
