class PublicController < ApplicationController
  skip_before_filter :require_user
  
  layout "public"
  def index
    if current_account
      redirect_to login_path
    end
  end

end
