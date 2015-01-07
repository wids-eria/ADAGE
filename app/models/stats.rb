class Stat < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  validates_presence_of :user,:game,:key
  attr_accessible :key, :value, :game, :user
end
