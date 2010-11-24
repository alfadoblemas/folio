class CreateInvoiceItems < ActiveRecord::Migration
  def self.up
    create_table :invoice_items do |t|
      t.string :unit
      t.integer :quantity
      t.text :description
      t.integer :price
      t.integer :total
      t.integer :invoice_id

      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_items
  end
end
