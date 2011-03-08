class UsersController < ApplicationController  
  #before_filter :current_account_admin, :except => [:create, :update, :destroy]
  before_filter :find_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def show
  end

  def edit
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Usuario creado."
      redirect_to account_path(current_account.id)
    else
      render :action => 'new'
    end
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Datos actualizados."
      redirect_to user_path(@user)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
  end
  
  private
  def current_account_admin
    if (params[:account_id].to_i == current_account.id) && account_admin?
      return
    else
      render :template => "/shared/error/404.html.erb", :status => 404, :layout => "error"
    end
  end
  
  def find_user
    @user = User.find(params[:id], :conditions => ["account_id = ?", current_account.id ])
  end

end
