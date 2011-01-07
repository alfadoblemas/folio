class AlterInvoiceItemProductId < ActiveRecord::Migration
  def self.up
    change_table :invoice_items do |t|
      t.change :product_id, :integer
    end
  end

  def self.down
  end
end
