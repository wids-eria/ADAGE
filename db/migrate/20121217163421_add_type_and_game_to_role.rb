class AddTypeAndGameToRole < ActiveRecord::Migration
  def change
    add_column :roles, :type, :string
    add_column :roles, :game_id, :integer
  end
end
