class RolesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  
  belongs_to :assigner, :class_name => 'User'

end
