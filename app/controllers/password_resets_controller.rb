class PasswordResetsController < ApplicationController
  skip_before_filter :require_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  layout "public"

  def new
    @user = User.new
    render
  end
  
  def edit
    render
  end
  
  def create
    @account = Account.find_by_subdomain(current_subdomain)
    @user = User.find_by_email(params[:email], :conditions => ["account_id = ?", @account.id])
    if @user
      @user.send_later(:deliver_password_reset_instructions!)
      flash[:notice] = "Las instrucciones para actualizar la contraseña fueron enviadas a su email."
      redirect_to application_root_url(:subdomain => @account.subdomain)
    else
      flash[:notice] = "No encontramos ningún usuario con el email ingresado."
      render :action => "new"
    end
  end
  
  def update
    subdomain = @user.account.subdomain
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Contraseña actualizada correctamente."
      redirect_to application_root_url(:subdomain => subdomain)
    else
      flash[:notice] = "Las contraseñas ingresadas no coinciden.<br/>Por favor intente nuevamente."
      render :action => "edit"
    end
  end
  
  
  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "Por seguridad, el link para cambiar contraseña ha expirado."
      redirect_to application_root_url(:subdomain => current_subdomain)
    end
  end
  
end
