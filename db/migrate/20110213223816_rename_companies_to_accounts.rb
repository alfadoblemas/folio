class RenameCompaniesToAccounts < ActiveRecord::Migration
  def self.up
    rename_table :companies, :accounts
  end

  def self.down
    rename_table :accounts, :companies
  end
end
