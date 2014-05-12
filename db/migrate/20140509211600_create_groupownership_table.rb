class CreateGroupownershipTable < ActiveRecord::Migration
  def up
    create_table :groupownerships do |t|
      t.references :groupownerships, :user
      t.references :groupownerships, :group
    end
  end

  def down
    drop_table :groupownerships
  end
end
