class CreateAccessTokens < ActiveRecord::Migration
  def change
    create_table :access_tokens do |t|
      t.string :consumer_token
      t.string :consumer_secret

      t.timestamps
    end
  end
end
