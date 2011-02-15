class AddColumnsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :subdomain, :string
    add_column :accounts, :admin_id, :integer
    add_index :accounts, :admin_id, :name => "accounts_admin_index"
  end

  def self.down
    remove_column :accounts, :subdomain
    remove_column :accounts, :admin_id
  end
end
