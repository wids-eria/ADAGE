class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :app_token
      t.string :app_secret

      t.timestamps
    end
  end
end
