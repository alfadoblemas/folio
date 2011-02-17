class PublicController < ApplicationController
  layout "public"
  def index
    if current_account
      redirect_to login_path
    else
      redirect_to 404
    end
  end

end
