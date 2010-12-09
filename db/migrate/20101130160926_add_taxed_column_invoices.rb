class AddTaxedColumnInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :taxed, :boolean
  end

  def self.down
    add_column :invoices, :taxed
  end
end
