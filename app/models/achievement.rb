class Achievement < ActiveRecord::Base

  serialize :data, ActiveRecord::Coders::Hstore
  belongs_to :user
  belongs_to :game

  validates_presence_of :user,:game
  attr_accessible :data, :game, :user
end
