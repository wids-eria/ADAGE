class Organization < ActiveRecord::Base
  after_create :create_roles

  attr_accessible :name
  validates :name, uniqueness: { case_sensitive: false }
  has_many :organization_roles
  has_many :users, through: :organization_roles

  def create_roles
  #  OrganizationRole.create(organization: self,name: "Admin")
  end
end
