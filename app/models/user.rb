class User < ActiveRecord::Base

  #Assoc
  belongs_to :account
  has_many :histories

  acts_as_authentic do |c|
    c.validations_scope = :account_id
  end
  
  validates_presence_of :password

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
  end
  
  def account_admin?
    id == account.admin_id ? true : false
  end

end
