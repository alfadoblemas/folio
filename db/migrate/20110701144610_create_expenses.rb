class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      
      t.integer :account_id
      t.integer :user_id
      t.integer :vendor_id
      t.integer :category
      t.integer :total
      t.integer :attachment_category
      t.integer :receipt
      t.string :attachment_subject
      t.string :subject
      t.text :comment
      
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.datetime :attachment_updated_at
      t.integer :attachment_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
