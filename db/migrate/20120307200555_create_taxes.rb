class CreateTaxes < ActiveRecord::Migration
  def self.up
    create_table :taxes do |t|
      t.string :name
      t.float :value
      t.integer :account_id

      t.timestamps
    end
    add_index :taxes, :account_id
  end

  def self.down
    remove_index :taxes, :account_id
    drop_table :taxes
  end
end