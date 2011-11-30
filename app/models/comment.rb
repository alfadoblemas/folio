class Comment < ActiveRecord::Base

  before_create :set_account_id
  before_destroy :system_comment

  validates_presence_of :body, :invoice_id

  belongs_to :invoice
  belongs_to :user
  belongs_to :account
  belongs_to :comment_type

  def self.find_for_dashboard(params_hash)
    paginate(:page => params_hash[:page], :per_page => 5,
             :order => "created_at desc" ,
             :conditions => ["account_id = ?", params_hash[:account].id])
  end
  
  def user_avatar
    user.avatar_thumb_url
  end
  
  def user_name
    user.name
  end

  private
    def set_account_id
      self.account_id ||= self.user.account.id
    end

    def system_comment
      !self.system
    end

end
