class AddAchievments < ActiveRecord::Migration
  def up
    create_table(:achievements) do |t|
      t.column :data, :hstore
      t.references :game
      t.references :user
      t.timestamps
    end

    add_hstore_index :achievements, :data
  end

  def down
    drop_table :achievements
  end
end
