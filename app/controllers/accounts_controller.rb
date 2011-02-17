class AccountsController < ApplicationController
  
  layout "public", :except => [:show, :edit]
  
  def new
    @account = Account.new
    @account.users.build
  end

  def edit
    @account = Account.find(params[:id])
  end
  
  def create
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = "Cuenta creada!"
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
