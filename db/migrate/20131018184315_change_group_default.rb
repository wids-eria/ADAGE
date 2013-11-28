class ChangeGroupDefault < ActiveRecord::Migration
  def change
    change_column :groups, :playsquad, :boolean,:default =>true
  end
end
