class Group < ActiveRecord::Base
  has_and_belongs_to_many :users

  has_many :group_ownerships
  has_many :owners, through: :group_ownerships, source: :user

  before_create :generatecode

  scope :playsquads, -> { where(playsquad: 'true') }

  validates_presence_of :name
  validates_uniqueness_of :code, :name

  attr_accessible :name, :code, :user_ids, :playsquad, :owner

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
end