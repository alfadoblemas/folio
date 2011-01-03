class Contact < ActiveRecord::Base

  # Filtros
  before_save :downcase_email

  # Associations
  belongs_to :customer
  has_many :invoices

  # Validations
  validates_presence_of :first_name, :last_name, :email
  validates_format_of :email, :with => /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  validates_format_of :phone, :with => /^[\(\)0-9\- \+\.]{6,20}$/, :if => Proc.new {|contact| !contact.phone.blank?}
  validates_format_of :mobile, :with => /^[\(\)0-9\- \+\.]{8,20}$/, :if => Proc.new {|contact| !contact.mobile.blank?}

  def name
    self.first_name.titleize+" "+self.last_name.titleize
  end
  
  protected
  def downcase_email
    self.email = self.email.downcase  
  end
  
   
end
