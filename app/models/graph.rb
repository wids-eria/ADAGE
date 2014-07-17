class Graph < ActiveRecord::Base
  belongs_to :dashboard
  attr_accessible :dashboard, :settings, :metrics
  alias_attribute :filters, :settings
  validates :dashboard, presence: true
end
