class UsersController < ApplicationController  
  layout "application", :except => [:new]
  
  def new
    @user = User.new
    render :layout => "users/signup"
  end

  def edit
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Bienvenido a Folio."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

end
