class Invoice < ActiveRecord::Base

  # Associations
  belongs_to :customer
  belongs_to :contact
  belongs_to :company
  has_many :invoice_items

  # Extras
  accepts_nested_attributes_for :invoice_items

  # Validations
  validates_presence_of :number, :tax, :net, :total, :customer_id, :contact_id, :company_id
  validates_numericality_of :number, :only_integer => true
  validates_numericality_of :tax, :only_integer => true
  validates_numericality_of :net, :only_integer => true
  validates_numericality_of :total, :only_integer => true

end
