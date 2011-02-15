require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  
  user_tmpl = {:name => "patricio bruna", :email => "pbruna@itlinux.cl", :password => "1212121"}
  account_tmpl = {:name => "account", :subdomain => "lala"}
  
  test "account_subdomain should be uniq" do
    account1 = Account.new(account_tmpl)
    account1.users.build(user_tmpl)
    account2 = Account.new(account_tmpl)
    account2.users.build(user_tmpl)
    account1.save
    assert_equal(account1.users.first.name, "patricio bruna")
    assert !account2.save, "Account se guardada con subdomain duplicado"
  end
  
  test "account subdmain should not have dots" do
    account = Account.new(:name => "account3", :subdomain => "www.com")
    assert !account.save, "Subdominio se guarda si tiene puntos"
  end
  
  test "admin user should existe before account" do
    account = Account.new(account_tmpl)
    account.users.build(user_tmpl)
    account.save
    assert_equal(account.admin_id, account.users.first.id)
  end
  
end
