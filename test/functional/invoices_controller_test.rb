require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  fixtures :all
  
  def setup
    @request.host = 'itlinux.folio.com:3000'
  end
  
end
