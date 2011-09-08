class AddIndexesExpenses < ActiveRecord::Migration
  def self.up
    add_index :expenses, :account_id, :name => "expenses_account_index"
    add_index :expenses, :user_id, :name => "expenses_user_index"
    add_index :expenses, :vendor_id, :name => "expenses_vendor_index"
    add_index :expenses, :category, :name => "expenses_category_index"
    add_index :expenses, :receipt, :name => "expenses_receipt_index"
  end

  def self.down
    remove_index :expenses, :name => "expenses_account_index"
    remove_index :expenses, :name => "expenses_user_index"
    remove_index :expenses, :name => "expenses_vendor_index"
    remove_index :expenses, :name => "expenses_category_index"
    remove_index :expenses, :name => "expenses_receipt_index"
  end
end
