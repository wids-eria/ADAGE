class Game < ActiveRecord::Base

  attr_accessible :name
  validates :name, uniqueness: true
  has_many :schemas

end
