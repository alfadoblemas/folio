class Account < ActiveRecord::Base
  # Filters
  before_validation :downcase_subdomain
  after_save :add_admin, :if => :admin_null?
  before_save :randomize_file_name

  # Associations
  authenticates_many :user_sessions
  has_many :invoices
  has_many :users, :uniq => true
  accepts_nested_attributes_for :users
  has_many :customers
  has_many :contacts
  alias_attribute :user_id, :admin_id

  # Validations
  validates_presence_of :name, :subdomain
  validates_presence_of :rut, :on => :update
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_format_of :subdomain, :with => /^[\w\d]+$/, :on => :create
  
  has_attached_file :avatar,
    :url => "/images/accounts/avatars/:id/:style/:basename.:extension",
    :path => ":rails_root/public/images/accounts/avatars/:id/:style/:basename.:extension",
    :styles => {:medium => "100x100>", :thumb => "48x48"}

  def deliver_welcome_email!(password = nil)
    user = User.find(self.admin_id)
    UserMailer.deliver_welcome_email(user, self, password)
  end
  
  def have_logo?
    self.avatar_file_name.blank?
  end
  
  def have_invoices?
    self.invoices.size > 0 ? true : false
  end
  
  def have_customers?
    self.customers.size > 0 ? true : false
  end

  private
  def randomize_file_name
    return if avatar_file_name.nil?
    extension = File.extname(avatar_file_name).downcase
    if avatar_file_name_changed?
      self.avatar.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
    end
  end

  protected

    def admin_null?
      true if self.admin_id.nil?
    end

    def downcase_subdomain
      self.subdomain.downcase! if attribute_present?("subdomain")
    end

    def add_admin
      self.update_attribute(:admin_id, self.users.first.id)
    end

end
