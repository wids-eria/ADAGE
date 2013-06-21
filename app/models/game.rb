class Game < ActiveRecord::Base

  attr_accessible :name, :implementations
  validates :name, uniqueness: true
  has_many :implementations

end
