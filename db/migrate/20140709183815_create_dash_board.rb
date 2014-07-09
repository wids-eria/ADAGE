class CreateDashBoard < ActiveRecord::Migration
  def up
    create_table(:graphs) do |t|
      t.column :settings, :json
      t.column :metrics, :json
      t.timestamps
    end
    create_table(:dashboards) do |t|
      t.timestamps
    end
  end

  def down
    drop_table :graphs
    drop_table :dashboards
  end
end
