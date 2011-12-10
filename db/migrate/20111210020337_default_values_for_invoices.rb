class DefaultValuesForInvoices < ActiveRecord::Migration
  def self.up
    change_column_default :invoices, :total, 0
    change_column_default :invoices, :net, 0
    change_column_default :invoices, :tax, 0
  end

  def self.down
    change_column_default :invoices, :tax, nil
    change_column_default :invoices, :net, nil
    change_column_default :invoices, :total, nil
  end
end