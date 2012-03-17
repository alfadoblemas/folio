class ChangesToInvoicesBecauseNewTaxModel < ActiveRecord::Migration
  def self.up
    add_column :invoices, :tax_name, :string
    add_column :invoices, :tax_rate, :float
    change_column :invoices, :total, :float
    change_column :invoices, :net, :float
    change_column :invoices, :tax, :float
  end

  def self.down
    change_column :invoices, :column_name, :string
    change_column :invoices, :net, :string
    change_column :invoices, :total, :string
    remove_column :invoices, :tax_rate
    remove_column :invoices, :tax_name
  end
end