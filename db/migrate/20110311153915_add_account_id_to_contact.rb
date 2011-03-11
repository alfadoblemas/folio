class AddAccountIdToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :account_id, :integer
    add_index :contacts, :account_id, :name => "contacts_account_index"
  end

  def self.down
    remove_column :contacts, :account_id
    remove_index :contacts, :name => "contacts_account_index"
  end
end