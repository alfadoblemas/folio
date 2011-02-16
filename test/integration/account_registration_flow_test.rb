require 'test_helper'

class AccountRegistrationFlowTest < ActionController::IntegrationTest
  fixtures :all

  # Replace this with your real tests.
  test "create_new_account_and_login" do
    get "/signup"
    assert_response :success
    host!("localhost")
    post_via_redirect '/accounts', :account => { :name => "IT Linux", :subdomain => "lalala",
                                             'users_attributes' => { '0' =>
                                                                     {'name' => "patricio bruna", 'email' => 'pbruna2@gmail.com', 'password' => "123456", 'password_confirmation' => '123456' }
                                                                     }
                                             }
    assert_equal "#{host}/", "#{host}#{path}"
    assert_equal 0, assigns(:invoices).size
  end
end
