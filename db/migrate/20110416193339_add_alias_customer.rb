class AddAliasCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :alias, :string, :default => ""
  end

  def self.down
    remove_column :customers, :alias
  end
end