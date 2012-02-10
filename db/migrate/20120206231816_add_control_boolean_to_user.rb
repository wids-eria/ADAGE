class AddControlBooleanToUser < ActiveRecord::Migration
  def up
    add_column :users, :control_group, :boolean, :default => nil 
  end
end
