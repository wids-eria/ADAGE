class Dashboard < ActiveRecord::Base
  belongs_to :game , polymorphic: true
  belongs_to :user , polymorphic: true

  has_many :graphs

  attr_accessible :game, :user, :graphs
  validates :game, presence: true
end
