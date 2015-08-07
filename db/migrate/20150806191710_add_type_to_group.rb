class AddTypeToGroup < ActiveRecord::Migration

	def up
    	add_column :groups, :group_type, :string
	end

	def down
    	remove_column :groups, :type
	end
end
