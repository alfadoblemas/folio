class AddStatusIdToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :status_id, :integer, :default => 2
    add_index :expenses, :status_id, :name => "expenses_status" 
  end

  def self.down
    remove_column :expenses, :status_id
  end
end
