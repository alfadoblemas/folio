class Invoice < ActiveRecord::Base


  # Associations
  belongs_to :customer
  belongs_to :contact
  belongs_to :account
  belongs_to :status
  has_many :invoice_items, :dependent => :destroy
  has_many :histories, :dependent => :destroy

  # Extras
  accepts_nested_attributes_for :invoice_items, :allow_destroy => true
  accepts_nested_attributes_for :histories, :allow_destroy => true

  # Validations
  validates_presence_of :net, :tax, :total, :customer_id, :subject, :date, :number
  validates_uniqueness_of :number, :scope => [:taxed, :account_id]

  validates_numericality_of :tax, :only_integer => true
  validates_numericality_of :number, :only_integer => true, :greater_than => 0
  validates_numericality_of :net, :only_integer => true, :greater_than => 0
  validates_numericality_of :total, :only_integer => true, :greater_than => 0


  delegate :name, :state, :to => :status, :prefix => true
  delegate :name, :to => :customer, :prefix => true


  def active!(user)
    unless active?
      update_attribute(:status_id, 2)
      histories.build(:subject => "Activación", :comment => "Factura activada", :user_id => user.id,
                      :account_id => user.account_id, :history_type_id => 7)
      save
    else
      false
    end
  end

  def active?
    status_id == 2 ? true : false
  end

  def cancel!(user)
    unless cancelled?
      update_attribute(:status_id, 4)
      histories.build(:subject => "Anulación", :comment => "La factura fue anulada", :user_id => user.id,
                      :account_id => user.account_id, :history_type_id => 7)
      save
    else
      false
    end
  end

  def cancelled?
    status_id == 4 ? true : false
  end

  def close!(user)
    unless closed?
      update_attribute(:status_id, 3)
      update_attribute(:close_date, Date.today)
      histories.build(:subject => "Pagada", :comment => "Factura pagada", :user_id => user.id,
                      :account_id => user.account_id, :history_type_id => 4)
      save
    else
      false
    end
  end

  def closed?
    status_id == 3 ? true : false
  end

  def draft?
    status_id == 1 ? true : false
  end

  def cancellable?
    status_id == 2 || status_id == 5 ? true : false
  end


  def self.duplicate(id)
    invoice = find(id)
    invoice.date = Date.today
    invoice.number = nil
    invoice.status_id = 1
    invoice_new = invoice.clone()
    invoice_new.invoice_items << invoice.duplicate_items
    invoice_new
  end

  def duplicate_items
    invoice_items_tmp = Array.new
    unless invoice_items.size < 0
      invoice_items.each_with_index do |line, index|
        invoice_items_tmp << line.clone()
      end
      invoice_items_tmp
    else
      false
    end
  end


  # Virtual attributes
  def customer_name
    customer.name if customer
  end

  def self.find_by_status(status, page , order = "number asc", account_id = nil, per_page = 10, eager = true)
    include_models = Array.new
    unless eager
      include_models = [:status]
    else
      include_models = [:status, :customer]
    end
    order = order.blank? ? "date desc" : order
    self.send("#{status}").paginate(
      :page => page,
      :per_page => per_page, :order => ["#{order}"],
      :include => include_models,
      :conditions => ["invoices.account_id = #{account_id}"]
    )

  end


  # Arreglo con Tipos de Facturas
  @statuses = %w( draft open close due cancel )

  # Metaprocreamos metodos de totales
  @statuses.each do |v|
    method_name = ("#{v}_total").to_sym
    self.class.send(:define_method, method_name) do |account, *query|
      query = *query
      sum = 0
      if query.nil?
        invoices = self.send("#{v}").search(:account_id_equals => account).all.to_a
        sum = invoices.sum(&:total) unless invoices.size < 1
        sum
      else
        query.delete("status")
        query[:account_id_equals] = account.to_i
        result = self.send("#{v}").search(query)
        invoices = result.all
        sum = invoices.sum(&:total) unless invoices.size < 1
        sum
      end
    end
  end

  def self.iva_total(query = nil)
    sum = 0
    if query.nil?
      invoices = all_invoices.to_a
      sum = invoices.sum(&:tax) unless invoices.size < 1
      sum
    else
      query.delete("status")
      result = all_invoices.search(query)
      invoices = result.all
      sum = invoices.sum(&:tax) unless invoices.size < 1
      sum
    end
  end

  def self.close_index_total(account, query = nil)
    sum = 0
    if query.nil?
      sum = close_index.search(:account_id_equals => account).all.to_a.sum(&:total) unless close_index.to_a.size < 1
      sum
    else
      query.delete("status")
      query[:account_id_equals] = account.to_i
      result = close.search(query)
      invoices = result.all
      sum = invoices.sum(&:total) unless invoices.size < 1
      sum
    end
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
      ["Este mes", 1.month.ago.to_date ],
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

  
  private
  
end
