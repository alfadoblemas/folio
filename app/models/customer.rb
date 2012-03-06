class Customer < ActiveRecord::Base

 #TODO: Ver si guardamos titleizados

# Index ABC Paginate
  paginate_alphabetically :by => :name

# Associations
  has_many :contacts, :dependent => :destroy, :order => "last_name, first_name"
  has_many :invoices
  belongs_to :account

# Validations
  validates_presence_of :name, :rut, :address, :city
  validates_uniqueness_of :rut, :scope => [:account_id]
  validates_format_of :phone, :with => /^[\(\)0-9\- \+\.]{6,20}$/, :if => Proc.new {|customer| !customer.phone.blank?}
  validates_format_of :fax, :with => /^[\(\)0-9\- \+\.]{6,20}$/, :if => Proc.new {|customer| !customer.fax.blank?}

# Extras
  accepts_nested_attributes_for :contacts

# Funciones

  def self.find_index(account)
    search = search(:account_id_equals => account)
    search.all(:order => "name", :include => [:contacts])
  end
  
  def self.find_show(account, id)
    find(id, :conditions => ["account_id = ?", account ],:include => [:invoices, :contacts])
  end
  
  def total_this_year
    sales = invoices.not_draft_cancel.date_in_between(Date.parse("01/01/#{Date.today.year}"),Date.today)
    sum_invoices(sales.to_a)
  end
  
  def total_all_time
    sales = invoices.not_draft_cancel
    sum_invoices(sales.to_a)
  end
  
  private
  def sum_invoices(array)
    sum = 0
    sum = array.sum(&:total) unless array.size < 1
    sum
  end
  

end
