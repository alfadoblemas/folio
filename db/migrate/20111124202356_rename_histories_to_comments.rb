class RenameHistoriesToComments < ActiveRecord::Migration
  def self.up
    rename_table :histories, :comments
  end

  def self.down
    rename_table :comments, :histories
  end
end