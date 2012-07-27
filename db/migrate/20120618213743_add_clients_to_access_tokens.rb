class AddClientsToAccessTokens < ActiveRecord::Migration
  def change
    add_column :access_tokens, :client_id, :integer
  end
end
