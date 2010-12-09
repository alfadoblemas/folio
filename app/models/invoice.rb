class Invoice < ActiveRecord::Base

  # Associations
  belongs_to :customer
  belongs_to :contact
  belongs_to :company
  belongs_to :status
  has_many :invoice_items, :dependent => :destroy
  has_many :histories

  # Extras
  accepts_nested_attributes_for :invoice_items, :allow_destroy => true

  # Validations
  validates_presence_of :net, :tax, :total, :customer_id, :number

  validates_numericality_of :tax, :only_integer => true
  validates_numericality_of :number, :only_integer => true
  validates_numericality_of :net, :only_integer => true, :greater_than => 0, :message => "No ha ingresado un monto Neto"
  validates_numericality_of :total, :only_integer => true, :greater_than => 0

end
