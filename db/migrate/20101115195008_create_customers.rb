class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :name
      t.string :rut
      t.text :address
      t.string :city
      t.string :industry
      t.string :state
      t.string :country

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
