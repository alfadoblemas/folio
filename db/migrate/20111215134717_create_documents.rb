class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer :user_id
      t.integer :account_id
      t.integer :invoice_id
      t.string :description

      t.timestamps
    end
    
    add_index :documents, :user_id
    add_index :documents, :account_id
    add_index :documents, :invoice_id
    
  end

  def self.down
    drop_table :documents
  end
end
