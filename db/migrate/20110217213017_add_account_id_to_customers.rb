class AddAccountIdToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :account_id, :integer
    add_index :customers, :account_id, :name => "customers_account_index"
  end

  def self.down
    remove_column :customers, :account_id
    remove_index :customers, :name => "customers_account_index"
  end
end