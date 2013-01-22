class RolesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  
  belongs_to :assigner, :class_name => 'User' 
  
  attr_accessible :user, :role, :assigner  

end
