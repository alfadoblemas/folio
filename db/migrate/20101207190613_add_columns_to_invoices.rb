class AddColumnsToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :due, :date
    add_column :invoices, :status_id, :integer
    add_column :invoices, :history_id, :integer
    add_column :invoices, :comment, :text
    add_column :invoices, :currency_id, :integer
    add_column :invoices, :date, :date
  end

  def self.down
    remove_column :invoices, :due
    remove_column :invoices, :status_id
    remove_column :invoices, :history_id
    remove_column :invoices, :comment
    remove_column :invoices, :currency_id
    remove_column :invoices, :date
  end
end
