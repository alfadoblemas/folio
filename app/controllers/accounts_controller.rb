class AccountsController < ApplicationController

  skip_before_filter :require_user, :only => [:new, :create]
  layout :wich_layout


  def sales_totals
    start_date = begin Date.parse(params[:start_date]) rescue Date.today.at_beginning_of_year end
    end_date = begin Date.parse(params[:end_date]) rescue Date.today.at_end_of_year end
    services_sales = current_account.total_of_services_between_dates(start_date, end_date)
    commodities_sales = current_account.total_of_commodities_between_dates(start_date, end_date)
    total = services_sales + commodities_sales
    sales = {:total => total, :services => services_sales, :commodities => commodities_sales }
    respond_to do |format|
      format.json {render :json => sales}
    end
  end

  def open_invoices_totals
    services_invoices = current_account.total_amount_of_service_for_open_invoices
    commodities_invoices = current_account.total_amount_of_commodity_for_open_invoices
    total = services_invoices + commodities_invoices
    sales = {:total => total, :services => services_invoices, :commodities => commodities_invoices }
    respond_to do |format|
      format.json {render :json => sales}
    end
  end


  def invoice_tags
    account = Account.find(current_account)
    @invoice_tags = account.invoice_tags
    render :json => @invoice_tags.to_json
  end

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
      redirect_to account_url(@account, :subdomain => @account.subdomain)
    else
      render :action => "edit"
    end
  end

  def show
    @tax = Tax.new
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
