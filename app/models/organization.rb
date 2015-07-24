class Organization < ActiveRecord::Base
  attr_accessible :name,:games
  validates :name, uniqueness: { case_sensitive: false }
  has_many :organization_roles
  has_many :users, through: :organization_roles
  has_many :games

end
