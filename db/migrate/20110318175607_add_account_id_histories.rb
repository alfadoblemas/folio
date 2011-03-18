class AddAccountIdHistories < ActiveRecord::Migration
  def self.up
    add_column :histories, :account_id, :integer
    add_index :histories, :account_id, :name => "histories_account_index"
  end

  def self.down
    remove_column :histories, :account_id
    remove_index :histories, :name => "histories_account_index"
  end
end