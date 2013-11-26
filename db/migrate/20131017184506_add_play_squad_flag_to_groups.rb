class AddPlaySquadFlagToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :playsquad, :boolean,:default =>false
  end

  def self.down
    remove_column :groups, :playsquad
  end
end
