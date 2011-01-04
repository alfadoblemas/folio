class AddSubjectColumnInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :subject, :string
  end

  def self.down
    remove_column :invoices, :subject
  end
end
