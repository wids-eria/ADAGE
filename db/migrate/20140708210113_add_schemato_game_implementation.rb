class AddSchematoGameImplementation < ActiveRecord::Migration
  def up
    add_column :implementations, :schema, :json
  end

  def down
    remove_column :implementations, :schema
  end
end
