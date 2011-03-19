class RenameEnableToActiveUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :enable, :active
  end

  def self.down
    rename_column :users, :active, :enable
  end
end