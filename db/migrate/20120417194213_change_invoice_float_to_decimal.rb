class ChangeInvoiceFloatToDecimal < ActiveRecord::Migration
  def self.up
    change_column :invoices, :total, :decimal, :precision => 10, :scale => 2
    change_column :invoices, :net, :decimal, :precision => 10, :scale => 2
    change_column :invoices, :tax, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    change_column :invoices, :tax, :float
    change_column :invoices, :net, :float
    change_column :invoices, :total, :float
  end
end