class RenameHistoryTypesToCommentTypes < ActiveRecord::Migration
  def self.up
    rename_table :history_types, :comment_types
  end

  def self.down
    rename_table :comment_types, :history_types
  end
end