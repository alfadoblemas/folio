require 'test_helper'

class UserCreateAndAdminTwoAccountsTest < ActionController::IntegrationTest

  # Replace this with your real tests.
  test "user_should_be_able_two_own_two_accounts" do
    get "/signup"
    host!("localhost.com")
    register_account("itlinux")
    register_account("gmail2")
  end

  private


    def register_account(subdomain)
      host!("localhost.com")
      post_via_redirect '/accounts', :account => { :name => subdomain, :subdomain => subdomain,
                                                   'users_attributes' => { '0' =>
                                                                           {'name' => "patricio bruna", 'email' => 'pbruna2@gmail.com', 'password' => "123456", 'password_confirmation' => '123456' }
                                                                           }
                                                   }
      assert_response :success
    end



end
