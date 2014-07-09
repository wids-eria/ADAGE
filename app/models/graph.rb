class Graph < ActiveRecord::Base
  belongs_to :dashboard
  attr_accessible :settings,:metrics
end
