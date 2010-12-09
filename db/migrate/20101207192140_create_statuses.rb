class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :name

      t.timestamps
    end


    Status.create(:id => 1, :name => "borrador".titleize)
    Status.create(:id => 2, :name => "abierta".titleize)
    Status.create(:id => 3, :name => "cerrada".titleize)

  end

  def self.down
    drop_table :statuses
  end
end
