class AddIndexes01 < ActiveRecord::Migration
  def self.up
    add_index :contacts, :customer_id, :name => "contacts_customer_index"
    add_index :customers, :name, :name => "customers_name_index"
    add_index :histories, :user_id, :name => "histories_user_index"
    add_index :histories, :invoice_id, :name => "histories_invoice_index"
    add_index :invoice_items, :product_id, :name => "iitems_product_index"
    add_index :invoice_items, :invoice_id, :name => "iitems_invoice_index"
    add_index :invoices, :number, :name => "invoices_number_index"
    add_index :invoices, :customer_id, :name => "invoices_customer_index"
    add_index :invoices, :contact_id, :name => "invoices_contact_index"
    add_index :invoices, :company_id, :name => "invoices_company_index"
    add_index :invoices, :status_id, :name => "invoices_status_index"
  end

  def self.down
  end
end
