class InvoiceItem < ActiveRecord::Base

# Associations
  belongs_to :invoice
  belongs_to :product

# Validations
  validates_presence_of :product_id, :price, :total, :quantity
  validates_numericality_of :product_id, :only_integer => true
  validates_numericality_of :price, :only_integer => true
  validates_numericality_of :quantity, :only_integer => true
  validates_numericality_of :total, :only_integer => true

end
