class OrganizationRole < ActiveRecord::Base
  attr_accessible :name,:organization,:user

  validates :name, uniqueness: { case_sensitive: false }
  belongs_to :organization
  belongs_to :user
end