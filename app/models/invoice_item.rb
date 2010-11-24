class InvoiceItem < ActiveRecord::Base

# Associations
  belongs_to :invoice

# Validations
  validates_presence_of :unit, :price, :total, :quantity
  validates_numericality_of :unit, :only_integer => true
  validates_numericality_of :price, :only_integer => true
  validates_numericality_of :quantity, :only_integer => true
  validates_numericality_of :total, :only_integer => true

end
