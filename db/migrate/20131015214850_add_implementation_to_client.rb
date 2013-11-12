class AddImplementationToClient < ActiveRecord::Migration
  def change
    add_column :clients, :implementation_id, :integer
  end
end
