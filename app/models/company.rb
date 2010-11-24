class Company < ActiveRecord::Base
 
# Associations
  has_many :invoices
  has_many :users

# Validations 
  validates_presence_of :name, :rut, :address, :city
  validates_uniqueness_of :rut
  validates_length_of :rut, :in => 11..13 

end
