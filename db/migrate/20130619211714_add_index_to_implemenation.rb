class AddIndexToImplemenation < ActiveRecord::Migration
  def change
   add_index :implementations, :game_id
  end
end
