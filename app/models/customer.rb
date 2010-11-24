class Customer < ActiveRecord::Base

 #TODO: Ver si guardamos titleizados

# Associations
  has_many :contacts, :dependent => :destroy, :order => "last_name, first_name"
  has_many :invoices

# Validations
  validates_presence_of :name, :rut, :address, :city, :message => "debe ser completado"
  validates_uniqueness_of :rut
  validates_length_of :rut, :in => 11..13

# Extras
accepts_nested_attributes_for :contacts

# Funciones

  def self.find_index
    self.find(:all, :order => "name")
  end

end
