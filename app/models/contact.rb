class Contact < ActiveRecord::Base

  # Associations
  belongs_to :customer
  has_many :invoices

  # Validations
  validates_presence_of :first_name, :last_name, :email

  def name
    self.first_name.titleize+" "+self.last_name.titleize
  end
  
   
end
