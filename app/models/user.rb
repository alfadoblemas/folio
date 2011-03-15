class User < ActiveRecord::Base

  #Assoc
  belongs_to :account
  has_many :histories

  acts_as_authentic do |c|
    c.validations_scope = :account_id
  end
  
  has_attached_file :avatar, :styles => {:medium => "300x300>", :thumb => "100x100>"}

  validates_presence_of :password

  def before_destroy
    raise "Admin can no be deleted" if account_admin?
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
    id == account.admin_id ? true : false
  end

end
