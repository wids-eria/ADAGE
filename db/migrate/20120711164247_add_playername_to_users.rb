class AddPlayernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :player_name, :string
  end
end
