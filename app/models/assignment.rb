class Assignment < ActiveRecord::Base
  belongs_to :role
  belongs_to :user
  belongs_to :assigner, :class_name => 'User' 
 
  validates_presence_of :user_id
  validates_presence_of :role_id

  attr_accessible :user, :role, :assigner  

end


