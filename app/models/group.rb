class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :games

  has_many :group_ownerships
  has_many :owners, through: :group_ownerships, source: :user
  has_many :teachers, through: :group_ownerships, source: :user

  belongs_to :organization
  before_create :generatecode

  scope :playsquads, -> { where(playsquad: 'true') }
  scope :classes, -> { where(group_type: 'class') }

  validates_presence_of :name,:organization,:group_type
  validates_uniqueness_of :code
  validate  :unique_name

  attr_accessible :name, :code, :user_ids, :playsquad, :owner,:organization,:organization_id,:type,:games

  def AddUser(user)
    unless user.nil?
      self.users << user
    end
  end

  def RemoveUser(user)
    unless user.nil?
      self.users.delete(user)
    end
  end

  private

  def generatecode
    #Generate zoopass until there is no collision
    pass = ZooPass.generate(4)
    while Group.find_by_code(pass)
      pass = ZooPass.generate(4)
    end
    self.code = pass
  end

  def unique_name
    count = Group.where(organization_id: self.organization,name: self.name.downcase).count
    if count != 0
      errors.add(:game, "Name must be unique")
    end
  end
end