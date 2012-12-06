class Schema < ActiveRecord::Base
  belongs_to :game
  attr_accessible :name, :game
  
  
end
