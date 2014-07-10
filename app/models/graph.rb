class Graph < ActiveRecord::Base
  belongs_to :dashboard
  attr_accessible :dashboard, :settings, :metrics
  validates :dashboard, presence: true
end
