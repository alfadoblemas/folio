class UserObserver < ActiveRecord::Observer
  def after_create(user)
    account = Account.find(user.account_id)
    UserMailer.deliver_welcome_email(user, account)
  end
end
