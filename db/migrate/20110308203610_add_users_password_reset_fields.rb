class AddUsersPasswordResetFields < ActiveRecord::Migration
  def self.up
    add_column :users, :perishable_token, :string, :default => "", :null => false
    add_index :users, :perishable_token, :name => "users_ptoken_index"
  end

  def self.down
    remove_column :users, :perishable_token
  end
end