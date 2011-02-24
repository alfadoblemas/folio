# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :require_user
  
  
  include App::Controller::Accounts
  include App::Controller::Users
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # Declaramos las funciones a usar para cada error
  rescue_from Exception,                            :with => :render_error
  rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
  rescue_from ActionController::RoutingError,       :with => :render_not_found
  rescue_from ActionController::UnknownController,  :with => :render_not_found
  rescue_from ActionController::UnknownAction,      :with => :render_not_found


  private

    # Funciones para mostrar páginas de errores
    def render_not_found(exception)
      log_error(exception)
      @no_sidebar = true
      render :template => "/shared/error/404.html.erb", :status => 404, :layout => "error"
    end

    def render_error(exception)
      log_error(exception)
      @no_sidebar = true
      render :template => "/shared/error/500.html.erb", :status => 500, :layout => "error"
    end

end
