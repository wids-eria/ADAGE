class AddIndexToPlayerName < ActiveRecord::Migration
  def change
    add_index :users, :player_name, { case_sensitive: false, unique: true }
  end
end
