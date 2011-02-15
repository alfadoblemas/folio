class RenameCompanyidAccountid < ActiveRecord::Migration
  def self.up
    rename_column :invoices, :company_id, :account_id
    remove_index :invoices, :name => "invoices_company_index"
    add_index :invoices, :account_id, :name => "invoices_account_index"
    
    rename_column :users, :company_id, :account_id
    remove_index :users, :name => "users_company_index"
    add_index :users, :account_id, :name => "users_account_index"
  end

  def self.down
  end
end
