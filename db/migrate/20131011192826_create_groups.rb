class CreateGroups < ActiveRecord::Migration
  def change
    create_table(:groups) do |t|
      t.string :code
      t.string :name
      t.timestamps
    end
  end
end
