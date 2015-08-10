class Game < ActiveRecord::Base

  attr_accessible :name, :implementations,:organization,:groups
  validate  :unique_name
  validates_presence_of :organization,:name

  has_and_belongs_to_many :groups

  has_many :implementations, dependent: :delete_all
  has_many :roles, dependent: :delete_all
  has_many :dashboards, dependent: :delete_all

  has_one :participant_role, dependent: :delete
  has_one :researcher_role, dependent: :delete
  has_one :developer_role, dependent: :delete
  belongs_to :organization

  after_create :create_collection
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

  def configs
    ConfigData.where("game_id" => self.id)
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

  def create_collection
    #Creates collection and add indices
    db = Mongoid::Sessions.default
    gamename = self.name.to_s.gsub(' ', '_')
    collection = db[gamename]
    collection.indexes.create(name: 1)
    collection.indexes.create(gameName: 1)
    collection.indexes.create(user_id: 1)
    collection.indexes.create(timestamp: 1)
    collection.indexes.create({ adage_version: 1, startContextID: 1,key: 1, created_at: 1 })
  end

  def unique_name
    count = Game.where(organization_id: self.organization,name: self.name.downcase).count
    if count != 0
      errors.add(:game, "Name must be unique")
    end
  end
end
