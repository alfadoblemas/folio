class UserSessionsController < ApplicationController
  layout 'public'
  before_filter :require_no_user, :only => [:new, :create], :if => :subdomain?
  before_filter :require_user, :only => :destroy

  def new
    if current_subdomain.nil?
      render :action => "new"
    elsif current_account.nil?
      raise ActionController::RoutingError.new('Not Found')
    else
      @user_session = current_account.user_sessions.new
    end
  end

  def create
    @user_session = current_account.user_sessions.new(params[:user_session])
    if @user_session.save
      redirect_back_or_default application_root_url
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_back_or_default login_url
  end

end
