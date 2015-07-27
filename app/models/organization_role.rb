class OrganizationRole < ActiveRecord::Base
  attr_accessible :name,:organization,:user
  validates_presence_of :organization,:name,:user

  belongs_to :organization
  belongs_to :user
end