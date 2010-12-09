class AddProducts < ActiveRecord::Migration
  def self.up
    Product.create(:id => 1, :name => "horas".titleize)
    Product.create(:id => 2, :name => "servicio".titleize)
    Product.create(:id => 3, :name => "producto".titleize)
  end

  def self.down
  end
end
