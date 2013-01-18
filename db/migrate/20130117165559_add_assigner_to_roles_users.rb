class AddAssignerToRolesUsers < ActiveRecord::Migration
  def change
    add_column :roles_users, :assigner_id, :integer
  end
end
