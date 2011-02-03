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

  def self.find_by_status(status, page , order = "number asc", per_page = 10, company_id = nil)
    order = order.blank? ? "date desc" : order
    self.send("#{status}").paginate(
      :page => page,
      :per_page => per_page, :order => ["#{order}"],
      :include => [:status]
    )

  end


  # Arreglo con Tipos de Facturas
  @statuses = Status.find(:all, :select => [:state]).map {|s| {:status => s.state} }

  # Metaprocreamos metodos de totales
  @statuses.each do |v|
    method_name = ("#{v[:status]}_total").to_sym
    self.class.send(:define_method, method_name) do |*query|
      query = *query
      sum = 0
      if query.nil?
        invoices = self.send("#{v[:status]}").to_a
        sum = invoices.sum(&:total) unless invoices.size < 1
        sum
      elsif
        query.delete("status")
        result = self.send("#{v[:status]}").search(query)
        invoices = result.all
        sum = invoices.sum(&:total) unless invoices.size < 1
        sum
      end
    end
  end

  def self.close_index_total(query = nil)
    sum = 0
    if query.nil?
      sum = close_index.to_a.sum(&:total) unless close_index.to_a.size < 1
      sum
    elsif
      query.delete("status")
      result = close.search(query)
      invoices = result.all
      sum = invoices.sum(&:total) unless invoices.size < 1
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
  
  def self.date_filter
    dates = Array.new
    dates = [
      ["1 Mes", 1.month.ago.to_date ],
      ["2 Meses", 2.month.ago.to_date ],
      ["6 Meses", 6.month.ago.to_date ]
      ]
  end
  
  def self.statuses
    @statuses
  end
  
  def self.per_page
    10
  end
  
  # Estado de Facturas
  scope_procedure :due, lambda { status_id_equals(2).due_lt(Date.today) }
  scope_procedure :open, lambda { status_id_equals(2).due_gte(Date.today) }
  scope_procedure :close, lambda { status_id_equals(3) }
  scope_procedure :close_index, lambda { status_id_equals(3).close_date_gte(1.month.ago.to_date) }
  scope_procedure :draft, lambda { status_id_equals(1) }
  scope_procedure :cancel, lambda { status_id_equals(4) }
  scope_procedure :all_invoices, lambda { number_gte(0) }
  scope_procedure :untaxed, lambda { taxed_equals(false) }

  
end
