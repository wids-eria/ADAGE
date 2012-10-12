class AddPlayernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :player_name, :string, unique: true, default: ''
  end
end
