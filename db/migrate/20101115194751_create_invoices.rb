class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :number
      t.bool :taxed
      t.integer :tax
      t.integer :net
      t.integer :total
      t.integer :customer_id
      t.integer :contact_id
      t.integer :company_id

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
