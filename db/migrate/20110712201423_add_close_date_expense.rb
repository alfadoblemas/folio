class AddCloseDateExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :close_date, :date
  end

  def self.down
    remove_column :expenses, :close_date
  end
end
