class AddNotifyAccountUsersToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :notify_account_users, :string
  end

  def self.down
    remove_column :comments, :notify_account_users
  end
end