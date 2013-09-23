class CreateSocialAccessTokens < ActiveRecord::Migration
  def change
    create_table :social_access_tokens do |t|
      t.integer :uid
      t.string :provider
      t.string :access_token
      t.datetime :expired_at
      t.references :user

      t.timestamps
    end
    add_index :social_access_tokens, :user_id
  end
end
