class AddTokenToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.token_authenticatable
    end

    add_index :users, :authentication_token, :unique => true
  end
end
