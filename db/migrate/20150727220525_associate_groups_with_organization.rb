class AssociateGroupsWithOrganization < ActiveRecord::Migration
	def up
	  change_table :groups do |p|
	    p.references :organization, index: true
	  end
	end

	def down
  		remove_index :groups, :organization_id
  		remove_column :groups, :organization_id
	end
end
