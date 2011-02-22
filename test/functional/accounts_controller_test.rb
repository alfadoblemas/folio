require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  
  def setup
    @request.host = 'folio.com:3000'
  end
  
  test "new_account" do
    get 'new'
    assert_response :success
    assert_not_nil assigns(:account)
  end
  
  test 'should_create_account' do
    subdomain = "lalala"
    assert_difference('Account.count') do
      post :create, :account => { :name => "IT Linux", :subdomain => subdomain, 
        'users_attributes' => { '0' => {'name' => "patricio bruna", 'email' => 'pbruna2@gmail.com', 'password' => "123456", 'password_confirmation' => '123456' }}}
    end
    assert_redirected_to application_root_url(:subdomain => subdomain)
  end
  
  test 'account_new_only_from_public_root' do
    @request.host = 'gmail.localhost.com:3000'
    get "new", :controller => "accounts"
    assert_response :redirect
    assert_redirected_to application_root_url
  end
  
end
