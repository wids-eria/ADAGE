class CreateDashBoard < ActiveRecord::Migration
  def up
    create_table(:dashboards) do |t|
      t.integer :game_id
      t.integer :user_id
      t.timestamps
    end


    create_table(:graphs) do |t|
      t.integer :dashboard_id
      t.column :settings, :json
      t.column :metrics, :json
      t.timestamps
    end
  end

  def down
    drop_table :dashboards
    drop_table :graphs
  end
end
