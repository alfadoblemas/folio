class Expense < ActiveRecord::Base

  # Constants
  RECEIPT_CATEGORIES = [["Factura", 1], ["Boleta", 2], ["Otro", 3]]
  PAYMENT_METHODS = {
    "1" => {:name => "Efectivo", :class => "cash"},
    "2" => {:name => "Cheque", :class => "check"},
    "3" => {:name => "T. Crédito", :class => "card"},
    "4" => {:name => "Transferencia", :class => "transfer"},
    "5" => {:name => "Otro", :class => "other"}
    }    

  # Filters
  before_save :randomize_file_name

  # Associations
  belongs_to :vendor, :class_name => "Customer"
  belongs_to :user
  belongs_to :account
  belongs_to :status

  has_many :comments

  # Paperclip Attachment stuff
  has_attached_file :attachment,
    :url => '/:class/:id/attachment',
    :path => ':rails_root/assets/:class/:id_partition/:basename.:extension'

  validates_attachment_size :attachment, :less_than => 10.megabytes

  # Validations
  validates_presence_of :account_id, :user_id, :vendor_id, :subject
  validates_numericality_of :total, :only_integer => true, :greater_than => 0


  def vendor_name
    vendor.name
  end

  def payment_method_name
    PAYMENT_METHODS[payment_method.to_s][:name]
  end
  
  def payment_method_class
    PAYMENT_METHODS[payment_method.to_s][:class]
  end
  
  def self.payment_methods_for_select
    PAYMENT_METHODS.map {|k| [ k[1][:name], k[0].to_i]}
  end

  def status_name
    status.name[-1]="o"
    status.name
  end

  def status_id
    status_id = read_attribute(:status_id)
    due_date = read_attribute(:due_date)
    if status_id == 2 and due_date < Date.today
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
    ((today - due_date.to_time)/86400).to_i
   end

  def downloadble?(user)
    user.account_id == account_id
  end
  
  def active?
    self.status_id == 2 ? true : false
  end

  def closed?
    self.status_id == 3 ? true : false
  end
  
  def due?
    self.status_id == 5 ? true : false
  end
  
  def has_receipt?
    !self.attachment_file_name.blank?
  end
  
  def self.find_by_status(status, page , order = "date desc", account_id = nil, per_page = 10, eager = true)
    include_models = Array.new
    unless eager
      include_models = [:status]
    else
      include_models = [:status, :vendor]
    end
    order = order.blank? ? "created_at desc" : order
    self.send("#{status[0]}", status[1]).paginate(
      :page => page,
      :per_page => per_page, :order => ["#{order}"],
      :include => include_models,
      :conditions => ["expenses.account_id = ?", account_id]
    )
  end
  
  # Arreglo con Estado de Pagos
  STATUSES = %w( open close due )

  # Metaprocreamos metodos de totales
  STATUSES.each do |v|
    method_name = ("#{v}_total").to_sym
    self.class.send(:define_method, method_name) do |account, *query|
      query = *query
      sum = 0
      if query.nil?
        expenses = self.send("#{v}").search(:account_id_equals => account).all.to_a
        sum = expenses.sum(&:total) unless expenses.size < 1
        sum
      else
        query.delete("status")
        query[:account_id_equals] = account.to_i
        result = self.send("#{v}").search(query)
        expenses = result.all
        sum = expenses.sum(&:total) unless expenses.size < 1
        sum
      end
    end
  end
  
  named_scope :open, :conditions => ['status_id = 2 and due_date >= ?', Date.today]
  named_scope :due, :conditions => ['status_id = 2 and due_date < ?', Date.today]
  named_scope :close, :conditions => {:status_id => 3}
  named_scope :close_index, :conditions => ['status_id = 3 and close_date >= ?', 1.month.ago.to_date]
  named_scope :by_category, lambda {|category| { :conditions => ['category = ?', category] } }
  named_scope :by_payment_method, lambda {|pm| { :conditions => ['payment_method = ?', pm] } }
  named_scope :all_index, lambda {|account_id| { :conditions => ['account_id = ?', account_id] } }
  
  delegate :name, :state, :to => :status, :prefix => true

  private
    def randomize_file_name
      return if attachment_file_name.nil?
      extension = File.extname(attachment_file_name).downcase
      if attachment_file_name_changed?
        self.attachment.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
      end
    end
end
