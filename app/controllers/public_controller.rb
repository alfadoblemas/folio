class PublicController < ApplicationController
  layout "public"
  def index
    if current_account
      redirect_to login_path
    end
  end

end
