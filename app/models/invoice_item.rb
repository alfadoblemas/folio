class InvoiceItem < ActiveRecord::Base
  after_save :update_invoice_price
  after_destroy :update_invoice_price

# Associations
  belongs_to :invoice
  belongs_to :product

# Validations
  validates_presence_of :product_id, :price, :total, :quantity
  validates_numericality_of :product_id, :only_integer => true
  validates_numericality_of :price, :only_integer => true
  validates_numericality_of :quantity, :only_integer => true
  validates_numericality_of :total, :only_integer => true, :greater_than => 0



  private
  def update_invoice_price
    invoice.set_totals
  end

end
