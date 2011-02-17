# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Products
%w( horas servicio producto ).each_with_index do |name, index|
  id = index + 1
  Product.create!(:id => id, :name => name.titleize)
end

# Status
%w( borrador activa paga anulada vencida ).each_with_index do |name, index|
  id = index + 1
  Status.create!(:id => id, :name => name.titleize)
end

Status.update(1, :state => "draft")
Status.update(2, :state => "open")
Status.update(3, :state => "close")
Status.update(4, :state => "cancel")
Status.update(5, :state => "due")