class GroupInvite < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  validates_presence_of :user_id,:group_id
  attr_accessible :user,:group
end
