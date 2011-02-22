class AddColumnAccountIdToUser < ActiveRecord::Migration
  def self.up
    add_index :users, :account_id, :name => "users_account_index"
  end

  def self.down

  end
end
