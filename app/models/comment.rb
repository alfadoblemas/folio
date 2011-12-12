class Comment < ActiveRecord::Base

  before_create :set_account_id, :set_default_comment_type
  before_destroy :system_comment
  after_create :enqueue_notification_email

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

  def enqueue_notification_email
    unless self.system || notify_account_users.nil?
      users_ids = notify_account_users.split(/,/)
      users = {}
      User.find(users_ids).each do |user|
        users[user.id] = user
      end
      users_ids.each do |user_id|
        user = users[user_id.to_i]
        user.send_later(:deliver_comment_notification_email!, self.id, users.values)
      end
    end
  end

  private
    def set_account_id
      self.account_id ||= self.user.account.id
    end

    def set_default_comment_type
      self.comment_type_id ||= 1
    end

    def convert_user_ids_to_i
      self.notify_account_users.map! {|id| id.to_i}
    end

    def system_comment
      !self.system
    end

end
