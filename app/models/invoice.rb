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
  validates_uniqueness_of :number, :scope => [:tax, :company_id]

  validates_numericality_of :tax, :only_integer => true
  #validates_numericality_of :number, :only_integer => true
  validates_numericality_of :net, :only_integer => true, :greater_than => 0
  validates_numericality_of :total, :only_integer => true, :greater_than => 0

  # Virtual attributes
  def customer_name
    customer.name if customer
  end


  # Arreglo con Tipos de Facturas
  @kinds = [
    {:kind => "draft", :condition => "status_id = 1"},
    {:kind => "due", :condition => ["status_id = 2 and due < ?", Date.today] },
    {:kind => "open", :condition => ["status_id = 2 and due >= ?", Date.today] },
    {:kind => "close_index", :condition => "status_id = 3 and close_date > #{1.month.ago.to_date}"},
    {:kind => "close", :condition => "status_id = 3"},
    {:kind => "cancel", :condition => "status_id = 4"}
  ]

  # Busqueda de Facturas x tipo
  # para popular #index
  # con metaprograming definimos las funciones find_due, find_open, etc
  # El Codigo pa Lindo!!!
  @kinds.each do |v|
    method_name = ("find_#{v[:kind]}").to_sym
    self.class.send(:define_method, method_name) do |*optional|
      
      unless optional.size < 3
        sort, direction, page, per_page = optional
        self.paginate(:all, :conditions => v[:condition], :order => ["#{sort} #{direction}"], 
        :page => page, :per_page => per_page, :include => [:status, :customer] )
      else
        page, per_page = optional
        self.paginate(:all, :conditions => v[:condition], :order => ["number asc"],
         :page => page, :per_page => per_page, :include => [:status, :customer] )
      end
    end
  end

  # Buscamos los totales de Facturas
  @kinds.each do |v|
    method_name = ("#{v[:kind]}_total").to_sym
    self.class.send(:define_method, method_name) do 
      sum = 0
      result = self.find(:all, :conditions => v[:condition])
      sum = result.sum(&:total) unless result.size < 1
      sum
    end
  end

  def customer_name
    self.customer.name
  end
  
  def status_id
    status_id = read_attribute(:status_id)
    due = read_attribute(:due)
    if status_id == 2 and due < Date.today
      5
    else
      status_id
    end
  end
  
  def state
    if self.status_id == 5
      "due"
    else
      self.status.state
    end
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
  
  def self.per_page
    10
  end
  
  scope_procedure :due_invoice, lambda { status_id_equals(2).due_lt(Date.today) }
  scope_procedure :open_invoice, lambda { status_id_equals(2).due_gte(Date.today) }
  scope_procedure :close_invoice, lambda { status_id_equals(3) }
  scope_procedure :draft_invoice, lambda { status_id_equals(1) }
  scope_procedure :cancel_invoice, lambda { status_id_equals(4) }

  
end
