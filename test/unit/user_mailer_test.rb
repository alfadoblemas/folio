require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  fixtures :users, :accounts
  
  test "welcome_email" do
    
    account = accounts(:gmail)
    user = users(:users_4)

    email = UserMailer.deliver_welcome_email(user, account)
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [user.email], email.to
    assert_equal "Bienvenido a Folio", email.subject
    assert_match "Hola #{@name}", email.body
  end

end
