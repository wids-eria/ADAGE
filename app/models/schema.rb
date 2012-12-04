class Schema < ActiveRecord::Base

  attr_accessible :name, :game
  validates :name, uniqueness: true


end
