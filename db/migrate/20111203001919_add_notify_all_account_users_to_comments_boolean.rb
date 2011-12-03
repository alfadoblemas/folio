class AddNotifyAllAccountUsersToCommentsBoolean < ActiveRecord::Migration
  def self.up
    add_column :comments, :notify_all_account_users, :boolean
  end

  def self.down
    remove_column :comments, :notify_all_account_users
  end
end
