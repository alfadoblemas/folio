class AccountsController < ApplicationController

  layout "public", :except => [:show, :edit]

  def new
    unless current_subdomain
      @account = Account.new
      @account.users.build
    else
      redirect_to application_root_url(:subdomain => current_subdomain)
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = "Cuenta creada!"
      logger.debug("aqui")
      logger.debug(current_user)
      redirect_to application_root_url(:subdomain => @account.subdomain)
    else
      render :action => :new
    end
  end

  def update
  end

  def show
  end

end