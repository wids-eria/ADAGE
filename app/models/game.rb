class Game < ActiveRecord::Base

  attr_accessible :name, :implementations
  validates :name, uniqueness: true
  has_many :implementations

  has_many :roles
  has_one :participant_role
  has_one :researcher_role
  has_one :developer_role

  after_create :create_researcher_role
  after_create :create_developer_role
  after_create :create_participant_role
  
  def users
   self.roles.where(id: participant_role.id).first.users   
  end

  def user_ids
   ids = self.roles.where(id: participant_role.id).first.users.collect{ |u| u.id}   
   return ids 
  end

  protected

  def create_researcher_role
    role = ResearcherRole.new(name: self.name, game: self)
    role.save  
    raise role.inspect if role.new_record?
  end

  def create_participant_role
    role = ParticipantRole.new(name: self.name, game: self)
    role.save  
    raise role.inspect if role.new_record?
  end

  def create_developer_role
    role = DeveloperRole.new(name: self.name, game: self)
    role.save  
    raise role.inspect if role.new_record?
  end

end
