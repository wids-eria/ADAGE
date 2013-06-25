class ResearcherRole < Role
  belongs_to :game

  attr_accessible :name, :game, :type
end
