class AddGamestoOrgs < ActiveRecord::Migration
	def up
	  change_table :games do |p|
	    p.references :organization, index: true
	  end
	end

	def down
  		remove_index :games, :organization_id
  		remove_column :games, :organization_id
	end
end