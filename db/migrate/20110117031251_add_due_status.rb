class AddDueStatus < ActiveRecord::Migration
  def self.up
  	Status.create(:id => 5, :name => "Vencida".titleize)
  end

  def self.down
  end
end
