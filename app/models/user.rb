class User < ActiveRecord::Base

  #Assoc
  belongs_to :account
  has_many :comments

  before_save :randomize_file_name

  acts_as_authentic do |c|
    c.validations_scope = :account_id
  end

  has_attached_file :avatar,
    :url => "/images/uploads/users/avatars/:id/:style/:basename.:extension",
    :path => ":rails_root/public/images/uploads/users/avatars/:id/:style/:basename.:extension",
    :styles => {:medium => "100x100>", :thumb => "48x48"}

  validates_presence_of :password, :on => :create

  def enable!
    self.update_attribute(:active, true)
  end

  def disable!
    self.update_attribute(:active, false)
  end

  def before_destroy
    raise "Admin can no be deleted" if account_admin?
  end

  def has_avatar?
    self.avatar_file_name.blank? ? false : true
  end

  def deliver_welcome_guest_email!(admin_user_id, password = nil)
    admin_user = User.find(admin_user_id)
    UserMailer.deliver_welcome_guest_email(self, self.account, admin_user, password)
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
  end

  def account_admin?
    self.admin ? true : false
  end
  
  def avatar_thumb_url
    avatar.url(:thumb)
  end
  
  named_scope :active, :conditions => ["active == ?", true], :order => 'name'

  private
    def randomize_file_name
      return if avatar_file_name.nil?
      extension = File.extname(avatar_file_name).downcase
      if avatar_file_name_changed?
        self.avatar.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
      end
    end

end
