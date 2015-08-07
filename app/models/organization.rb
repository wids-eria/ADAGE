class Organization < ActiveRecord::Base
  attr_accessible :name,:games,:groups,:subdomain
  validates :name, uniqueness: { case_sensitive: false }
  validates :subdomain, uniqueness: { case_sensitive: false }
  has_many :organization_roles, dependent: :delete_all
  has_many :users, through: :organization_roles
  has_many :games, dependent: :delete_all
  has_many :groups, dependent: :delete_all
end