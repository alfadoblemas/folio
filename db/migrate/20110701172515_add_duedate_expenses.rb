class AddDuedateExpenses < ActiveRecord::Migration
  def self.up
    add_column :expenses, :duedate, :date
  end

  def self.down
    remove_column :expenses, :duedate
  end
end
