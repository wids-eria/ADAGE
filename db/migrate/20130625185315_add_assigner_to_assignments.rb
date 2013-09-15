class AddAssignerToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :assigner_id, :integer, foreign_key: {references: :users} 
  end
end
