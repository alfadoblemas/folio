class AddSystemHistory < ActiveRecord::Migration
  def self.up
    add_column :histories, :system, :boolean, :default => false
  end

  def self.down
    remove_column :histories, :system
  end
end