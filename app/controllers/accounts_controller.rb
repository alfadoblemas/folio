class AccountsController < ApplicationController

  skip_before_filter :require_user, :only => [:new, :create]
  layout :wich_layout


  def new
    unless current_subdomain
      @account = Account.new
      @account.users.build
    else
      redirect_to application_root_url(:subdomain => current_subdomain)
    end
  end

  def edit
    if account_admin?
      @account = Account.find(current_account)
    else
      render :template => "/shared/error/404.html.erb", :status => 404, :layout => "error"
    end
  end

  def create
    @account = Account.new(params[:account])
    @account.subdomain.downcase!
    password = params[:account][:users_attributes]["0"]["password"]
    if @account.save
      @account.send_later(:deliver_welcome_email!, password)
      flash.now[:notice] = "Hemos enviado la información para ingresar a su email."
      redirect_to application_root_url(:subdomain => @account.subdomain)
    else
      render :action => :new
    end
  end

  def update
    @account = Account.find(current_account)
    if @account.update_attributes(params[:account])
      flash[:notice] = "Información actualizada correctamente."
      redirect_to account_path(@account)
    else
      render :action => "edit"
    end
  end

  def show
    @account = Account.find(current_account)
  end

  private

    def wich_layout
      if current_account
        "application"
      else
        "public"
      end
    end

end
