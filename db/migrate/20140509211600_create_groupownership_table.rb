class CreateGroupownershipTable < ActiveRecord::Migration
  def up
    create_table :group_ownerships do |t|
      t.references :user
      t.references :group
    end
  end

  def down
    drop_table :group_ownerships
  end
end
