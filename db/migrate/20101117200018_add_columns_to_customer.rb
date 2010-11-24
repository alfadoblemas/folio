class AddColumnsToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :url, :string 
    add_column :customers, :phone, :string 
    add_column :customers, :fax, :string 
  end

  def self.down
    remove_column :customers, :url
    remove_column :customers, :phone
    remove_column :customers, :fax
  end
end
