class AddIndexes02 < ActiveRecord::Migration
  def self.up
    add_index :invoices, :history_id, :name => "invoices_history_index"
    add_index :invoices, :currency_id, :name => "invoices_currency_index"
    add_index :users, :company_id, :name => "users_company_index"
  end

  def self.down
  end
end
