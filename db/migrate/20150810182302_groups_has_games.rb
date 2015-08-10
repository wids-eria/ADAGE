class GroupsHasGames < ActiveRecord::Migration
	def up
    create_table :games_groups, :id => false do |t|
      t.references :game, :group
    end
  end

  def down
    drop_table :games_groups
  end
end