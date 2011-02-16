class Account < ActiveRecord::Base
  # Filters
  before_validation :downcase_subdomain
  after_save :add_admin, :if => :admin_null?

  # Associations
  authenticates_many :user_sessions
  has_many :invoices
  has_many :users
  accepts_nested_attributes_for :users
  has_many :customers
  alias_attribute :user_id, :admin_id

  # Validations
  validates_presence_of :name, :subdomain
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_format_of :subdomain, :with => /^[\w\d]+$/, :on => :create

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
