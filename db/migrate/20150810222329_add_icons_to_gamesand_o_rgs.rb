class AddIconsToGamesandORgs < ActiveRecord::Migration
  def up
    add_attachment :games, :image
    add_attachment :organizations, :logo
  end

  def down
    remove_attachment :games, :image
    remove_attachment :organizations, :logo
  end
end
