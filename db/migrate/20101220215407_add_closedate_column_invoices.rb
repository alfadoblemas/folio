class AddClosedateColumnInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :close_date, :date
  end

  def self.down
    remove_column :invoices, :close_date
  end
end
