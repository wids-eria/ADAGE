class Dashboard < ActiveRecord::Base
  belongs_to :implementation , polymorphic: true

  has_many :graphs
end
