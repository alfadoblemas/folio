class History < ActiveRecord::Base

  before_create :set_account_id
  before_destroy :system_comment

  validates_presence_of :comment, :invoice_id

  belongs_to :invoice
  belongs_to :user
  belongs_to :account
  belongs_to :history_type
  
  private
  def set_account_id
    self.account_id ||= self.user.account.id
  end
  
  def system_comment
    !self.system
  end
  
end
