class Customer < ActiveRecord::Base

 #TODO: Ver si guardamos titleizados

# Index ABC Paginate
  paginate_alphabetically :by => :name

# Associations
  has_many :contacts, :dependent => :destroy, :order => "last_name, first_name"
  has_many :invoices

# Validations
  validates_presence_of :name, :rut, :address, :city
  validates_uniqueness_of :rut
  

# Extras
  accepts_nested_attributes_for :contacts

# Funciones

  def self.find_index
    self.find(:all, :order => "name")
  end

end
