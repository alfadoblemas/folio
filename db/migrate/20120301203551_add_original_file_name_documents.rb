class AddOriginalFileNameDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :original_file_name, :string
  end

  def self.down
    remove_column :documents, :original_file_name
  end
end