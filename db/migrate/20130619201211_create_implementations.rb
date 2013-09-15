class CreateImplementations < ActiveRecord::Migration
  def change
    create_table :implementations do |t|
      t.string :name
      t.references :game

      t.timestamps
    end
  end
end
