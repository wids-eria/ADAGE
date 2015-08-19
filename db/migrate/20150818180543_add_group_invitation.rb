class AddGroupInvitation < ActiveRecord::Migration
  def up	
    create_table :group_invites do |t|
      t.references :group
      t.references :user
      t.timestamps
    end
  end

  def down

    drop_table :group_invites
  end
end
