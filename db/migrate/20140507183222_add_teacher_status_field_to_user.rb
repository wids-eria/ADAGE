class AddTeacherStatusFieldToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :teacher_status_cd, :integer
  end

  def self.down
    remove_column :users, :teacher_status_cd
  end
end
