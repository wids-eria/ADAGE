class CreateUserGroupsReferenceTable < ActiveRecord::Migration
  def up
    create_table :groups_users, :id => false do |t|
      t.references :group, :user
    end
  end

  def down
    drop_table :groups_users
  end
end
