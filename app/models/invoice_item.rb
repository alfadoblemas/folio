class InvoiceItem < ActiveRecord::Base
  after_save :update_invoice_price
  before_save :set_total_amount
  after_destroy :update_invoice_price

# Associations
  belongs_to :invoice
  belongs_to :product
  delegate :account, :to => :invoice

# Validations
  validates_presence_of :product_id, :price, :total, :quantity
  validates_numericality_of :product_id, :only_integer => true
  validates_numericality_of :price, :only_integer => true
  validates_numericality_of :quantity, :only_integer => true
  validates_numericality_of :total, :only_integer => true, :greater_than => 0

# scopes
  named_scope :commodity, :conditions => ["product_id = ?", 3]
  named_scope :service, :conditions => ["product_id != ?", 3]
  
  def commodity?
    return product_id == 3
  end
  
  def service?
    return product_id != 3
  end

  private
  def set_total_amount
    total = quantity * price
  end
  
  def update_invoice_price
    invoice.set_totals
  end

end
