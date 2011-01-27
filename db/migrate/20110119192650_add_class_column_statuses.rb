class AddClassColumnStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :state, :string
  end

  def self.down
    remove_column :statuses, :state
  end
end
