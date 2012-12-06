class CreateSchemas < ActiveRecord::Migration
  def change
    create_table :schemas do |t|
      t.string :name
      t.references :game

      t.timestamps
    end
    add_index :schemas, :game_id
  end
end
