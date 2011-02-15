class CorrectPersistenceTokenInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :pesistence_token, :persistence_token
  end

  def self.down
    rename_column :users, :persistence_token, :pesistence_token
  end
end