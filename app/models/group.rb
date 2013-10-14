class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  before_save :generatecode

  attr_accessible :name, :code, :user_ids

  def AddUser(user)
    unless user.nil?
      self.users << user
    end
  end

  def RemoveUser

  end

  private

  def generatecode
    self.code = ZooPass.generate(4)
  end
end