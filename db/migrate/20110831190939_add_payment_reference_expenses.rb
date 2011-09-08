class AddPaymentReferenceExpenses < ActiveRecord::Migration
  def self.up
    add_column :expenses, :payment_reference, :string
  end

  def self.down
    remove_column :expenses, :payment_reference
  end
end