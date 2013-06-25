class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :user_id
      t.integer :role_id
      t.integer :assigner_id, foreign_key: false 
      t.datetime :disabled_at

      t.timestamps
    end
  end
end
