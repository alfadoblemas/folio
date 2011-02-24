class CustomersController < ApplicationController
  
  before_filter :find_customer, :only => [ :edit, :update, :destroy ]
  auto_complete_for :customers, :name

  def search
    unless params[:q].nil?
      search = Customer.search(:name_like => params[:q], :account_id_equals => current_account.id)
      @customers = search.all
    end

    respond_to do |format|
      format.xml { render :xml => @customers}
      format.json { render :json => @customers}
    end

  end

  def index
    @customers = Customer.find_index(current_account.id)
    @customer_alphabetical = Customer.alphabetical_group(current_account.id,params[:letter])
    respond_to do |format|
      format.html
    end
  end


  def show
    @customer = Customer.find_show(params[:id])
    @status = params[:status].blank? ? "all" : params[:status]
    order = "#{params[:sort]} #{params[:direction]}"
    @invoices = @customer.invoices.find_by_status(@status, params[:page], order)
  end



  def new
    @customer = Customer.new
  end

  def edit
    logger.debug(request.method)
  end

  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        if params[:referrer_invoice].to_i == 1
          flash[:notice] = "Cliente creado correctamente. Puede crear su Factura"
          format.html { redirect_to(new_customer_invoice_path(@customer))}
        else
          flash[:notice] = "Cliente creado correctamente"
          format.html { redirect_to(@customer)}
        end

      else
        format.html { render :action => "new"}
      end
    end

  end

  def update
    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        flash[:notice] = "Cambios guardados correctamente."
        format.html { redirect_to customer_path(@customer) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @customer.destroy
    respond_to do |format|
      flash[:notice] = "Cliente #{@customer.name} eliminado"
      format.html { redirect_to(customers_path) }
      format.xml  { head :ok }
    end
  end

  protected

  def find_customer
    @customer = Customer.find(params[:id])
  end

end
