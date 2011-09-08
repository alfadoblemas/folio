class AddPaymentMethodExpenses < ActiveRecord::Migration
  def self.up
    add_column :expenses, :payment_method, :integer, :default => 1
  end

  def self.down
    remove_column :expenses, :payment_method
  end
end