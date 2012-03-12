class AddTaxidToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :tax_id, :integer
    add_index :invoices, :tax_id
  end

  def self.down
    remove_index :invoices, :tax_id
    remove_column :invoices, :tax_id
  end
end