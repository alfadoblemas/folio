class Invoice < ActiveRecord::Base

  # Associations
  belongs_to :customer
  belongs_to :contact
  belongs_to :company
  belongs_to :status
  has_many :invoice_items, :dependent => :destroy
  has_many :histories, :dependent => :destroy

  # Extras
  accepts_nested_attributes_for :invoice_items, :allow_destroy => true
  accepts_nested_attributes_for :histories, :allow_destroy => true

  # Validations
  validates_presence_of :net, :tax, :total, :customer_id

  validates_numericality_of :tax, :only_integer => true
  #validates_numericality_of :number, :only_integer => true
  validates_numericality_of :net, :only_integer => true, :greater_than => 0
  validates_numericality_of :total, :only_integer => true, :greater_than => 0

  # Virtual attributes
  def customer_name
    customer.name if customer
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['number = ?', "#{search}"])
    end
  end
  
  def self.find_draft
    self.find(:all, :conditions => ['status_id = 1'])
  end

  def self.find_due
    self.find(:all, :conditions => ['status_id = 2 and due < ?', Date.today])
  end

  def self.find_open
    self.find(:all, :conditions => ['status_id = 2 and due >= ?', Date.today])
  end

  def self.find_close
    self.find(:all, :conditions => ['status_id = 3 and close_date > ?', 1.month.ago ])
  end
  
  def self.draft_total
    sum = 0
    sum = self.find_draft.sum(&:total) unless self.find_draft.size < 1
    sum
  end
  
  def self.open_total
    sum = 0
    sum = self.find_open.sum(&:total) unless self.find_open.size < 1
    sum
  end
  
  def self.close_total
    sum = 0
    sum = self.find_close.sum(&:total) unless self.find_close.size < 1
    sum
  end
  
  def self.due_total
    sum = 0
    sum = self.find_due.sum(&:total) unless self.find_due.size < 1
    sum
  end

def method_name
  
end

  def due_days
    today = Time.now
    ((today - self.due.to_time)/86400).to_i
  end

  def self.due_dates
    dates = Array.new
    dates << Duedate.new(30, "30 días")
    dates << Duedate.new(45, "45 días")
    dates << Duedate.new(60, "60 días")
    dates << Duedate.new(120, "120 días")
    dates << Duedate.new(0, "Contado")
    dates
  end

end
