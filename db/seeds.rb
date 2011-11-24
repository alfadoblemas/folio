# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Products
[
  { :id => 1, :name => "Horas" },
  { :id => 2, :name => "Servicio" },
  { :id => 3, :name => "Producto" }
].each do |product|
  Product.find_or_create_by_name(product)
end

# Status
[
  { :id => 1, :name => "Borrador", :state => "draft" },
  { :id => 2, :name => "Activa", :state => "open" },
  { :id => 3, :name => "Pagada", :state => "close" },
  { :id => 4, :name => "Anulada", :state => "cancel" },
  { :id => 5, :name => "Vencida", :state => "due" }
].each do |status|
  Status.find_or_create_by_name(status)
end

# Comment Types
[
  { :id => 1, :name => "comentario" },
  { :id => 2, :name => "enviada" },
  { :id => 3, :name => "nueva" },
  { :id => 4, :name => "pagada"},
  { :id => 5, :name => "perdida" },
  { :id => 6, :name => "ganada" },
  { :id => 7, :name => "aviso" }
].each do |type|
  CommentType.find_or_create_by_name(type)
end
