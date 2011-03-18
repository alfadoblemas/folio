class AddAdminAndEnableToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :enable, :boolean, :default => true
  end

  def self.down
    remove_column :users, :enable
    remove_column :users, :admin
  end
end