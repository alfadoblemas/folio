class AddDefaultTaxToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :default_tax_id, :integer
    add_index :accounts, :default_tax_id
  end

  def self.down
    remove_index :accounts, :default_tax_id
    remove_column :accounts, :default_tax_id
  end
end