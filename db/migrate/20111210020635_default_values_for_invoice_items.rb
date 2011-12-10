class DefaultValuesForInvoiceItems < ActiveRecord::Migration
  def self.up
    change_column_default :invoice_items, :total, 0
  end

  def self.down
    change_column_default :invoice_items, :total, nil
  end
end