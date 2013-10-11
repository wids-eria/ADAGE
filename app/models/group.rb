class Group < ActiveRecord::Base
  has_many :users

  attr_accessible :name,:code

  def AddUser

  end

  def RemoveUser

  end
end