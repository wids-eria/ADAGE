class ExpandUidIntSize < ActiveRecord::Migration
  def up
    change_column :social_access_tokens, :uid, :string
  end

  def down
    change_column :social_access_tokens, :uid, :integer
  end
end
