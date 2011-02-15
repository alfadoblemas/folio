class AccountsController < ApplicationController
  
  layout "application", :except => [:new]
  
  def new
    @account = Account.new
    @account.users.build
    render :layout => "accounts/signup"
  end

  def edit
    @user = Account.new(params[:account])
    if @user.save
      flash[:notice] = "Bienvenido a Folio."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def update
  end

  def show
  end

end
