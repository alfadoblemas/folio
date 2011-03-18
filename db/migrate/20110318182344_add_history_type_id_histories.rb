class AddHistoryTypeIdHistories < ActiveRecord::Migration
  def self.up
    add_column :histories, :history_type_id, :integer
    add_index :histories, :history_type_id, :name => "histories_type_index"
  end

  def self.down
    remove_column :histories, :history_type_id
    remove_index :histories, :name => "histories_type_index"
  end
end