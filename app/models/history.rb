class History < ActiveRecord::Base

  before_create :set_account_id

  validates_presence_of :comment, :invoice_id

  belongs_to :invoice
  belongs_to :user
  belongs_to :account
  belongs_to :history_type
  
  private
  def set_account_id
    self.account_id ||= self.user.account.id
  end

end
