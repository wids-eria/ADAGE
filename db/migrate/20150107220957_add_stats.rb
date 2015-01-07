class AddStats < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION hstore';

    create_table(:stats) do |t|
      t.column :key, :string
      t.column :value, :hstore
      t.references :game
      t.references :user
      t.timestamps
    end

    add_hstore_index :stats, :value
  end

  def down
    drop_table :stats
  end
end
