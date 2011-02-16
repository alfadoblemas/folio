class UserSessionsController < ApplicationController
  layout 'public'

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to application_root_url
    else
      render :action => "new"
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Bye bye"
    redirect_to public_root_url
  end

end
