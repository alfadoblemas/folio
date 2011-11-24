class RenameHistoryTypeIdColumnToCommentTypeId < ActiveRecord::Migration
  def self.up
    rename_column :comments, :history_type_id, :comment_type_id
  end

  def self.down
    rename_column :comments, :comment_type_id, :history_type_id
  end
end