class RenameUnitColumnInvoiceItems < ActiveRecord::Migration
  def self.up
    rename_column :invoice_items, :unit, :product_id
  end

  def self.down
    rename_column :invoice_items, :product_id, :unit
  end
end
