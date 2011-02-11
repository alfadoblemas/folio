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
  validates_format_of :phone, :with => /^[\(\)0-9\- \+\.]{6,20}$/, :if => Proc.new {|customer| !customer.phone.blank?}
  validates_format_of :fax, :with => /^[\(\)0-9\- \+\.]{6,20}$/, :if => Proc.new {|customer| !customer.fax.blank?}

# Extras
  accepts_nested_attributes_for :contacts

# Funciones

  def self.find_index
    self.find(:all, :order => "name", :include => [:contacts])
  end
  
  def self.find_show(id)
    find(id, :include => [:invoices])
  end

end
