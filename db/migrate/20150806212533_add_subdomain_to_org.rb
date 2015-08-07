class AddSubdomainToOrg < ActiveRecord::Migration
	def up
    	add_column :organizations, :subdomain, :string
	end

	def down
    	remove_column :organizations, :subdomain
	end
end
