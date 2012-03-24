class Customer < ActiveRecord::Base
 include ActionView::Helpers::NumberHelper

 #TODO: Ver si guardamos titleizados

# Index ABC Paginate
  paginate_alphabetically :by => :name

# Associations
  has_many :contacts, :dependent => :destroy, :order => "last_name, first_name"
  has_many :invoices
  belongs_to :account

# Validations
  validates_presence_of :name, :rut
  validates_uniqueness_of :rut, :scope => [:account_id]
  validate :rut_validation
  validates_format_of :phone, :with => /^[\(\)0-9\- \+\.]{6,20}$/, :if => Proc.new {|customer| !customer.phone.blank?}
  validates_format_of :fax, :with => /^[\(\)0-9\- \+\.]{6,20}$/, :if => Proc.new {|customer| !customer.fax.blank?}

# Extras
  accepts_nested_attributes_for :contacts
  before_save :format_rut


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
  
  def format_rut
    rut.gsub!(/\./,"")
    number, validator = rut.split(/-/)
    number = number_with_delimiter(number.to_i, :delimiter => '.')
    self.rut = "#{number}-#{validator}"
  end
  
  def rut_validation
    t = 0
    x = 9
    rut.gsub!(/\./,"")
    errors.add(:rut, "Formato incorrecto. Ej: xx.xxx.xxx-x") if rut !~ /(\d{7,8})-(\d|k)/
    number, validator = rut.split(/-/)
    number.reverse.split(//).each do |d| 
      t += d.to_i * x
      x = (x==4) ? 9 : x - 1
    end
    r = t % 11
    dv = (r==10) ? "k" : r
    errors.add(:rut, "No es un RUT válido") if validator.to_s != dv.to_s
  end

end
