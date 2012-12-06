class Game < ActiveRecord::Base

  attr_accessible :name, :schemas
  validates :name, uniqueness: true
  has_many :schemas

end
