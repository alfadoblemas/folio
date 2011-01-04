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
  validates_presence_of :net, :tax, :total, :customer_id, :subject
  validates_uniqueness_of :number

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


  # Arreglo con Tipos de Facturas
  @kinds = [
    {:kind => "draft", :condition => "status_id = 1"},
    {:kind => "due", :condition => ["status_id = 2 and due < ?", Date.today] },
    {:kind => "open", :condition => ["status_id = 2 and due >= ?", Date.today] },
    {:kind => "close", :condition => "status_id = 3 and close_date > #{1.month.ago.to_date}"}
  ]

  # Busqueda de Facturas x tipo
  # para popular #index
  # con metaprograming definimos las funciones find_due, find_open, etc
  # El Codigo pa Lindo!!!
  @kinds.each do |v|
    method_name = ("find_#{v[:kind]}").to_sym
    self.class.send(:define_method, method_name) do |*optional|
      unless optional.first.blank? && optional.second.blank?
        sort = optional.first
        direction = optional.second
        self.find(:all, :conditions => v[:condition], :order => ["#{sort} #{direction}"] )
      else
        self.find(:all, :conditions => v[:condition] )
      end
    end
  end

  def customer_name
    self.customer.name
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
  
  def self.kinds
    @kinds
  end

end
