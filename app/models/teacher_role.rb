class TeacherRole < Role
  belongs_to :game

  attr_accessible :name, :game, :type
  has_and_belongs_to_many :users
end
