class RenameDuedateExpenses < ActiveRecord::Migration
  def self.up
    rename_column :expenses, :duedate, :due_date
  end

  def self.down
    rename_column :expenses, :due_date, :duedate
  end
end
