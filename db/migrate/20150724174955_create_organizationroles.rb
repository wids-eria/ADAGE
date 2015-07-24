class CreateOrganizationroles < ActiveRecord::Migration
  def up
    create_table :organization_roles do |t|
      t.string :name
      t.references :user
      t.references :organization
      t.timestamps
    end

  end

  def down
    drop_table :organization_roles
  end
end
