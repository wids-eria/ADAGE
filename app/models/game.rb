class Game < ActiveRecord::Base

  attr_accessible :name, :schemas
  validates :name, uniqueness: true
  has_many :schemas
  after_create :create_researcher_role

  protected

  def create_researcher_role
    role = ResearcherRole.new(name: self.name, game: self)
    role.save  
    raise role.inspect if role.new_record?
  end

end
