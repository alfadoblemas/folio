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
  
  def invoices
    customer_invoices = Invoice.for_customer(params[:id])
    @status = params[:status].blank? ? "all_invoices" : params[:status]
    order = "#{params[:sort]} #{params[:direction]}"
    @order = order.blank? ? "date desc" : order
    
    @invoices = customer_invoices.find_by_status(@status).paginate(
      :page => params[:page],
      :per_page => 10, :order => @order
    )
    
    if request.xhr?
      xhr_endless_page_response("invoices/invoice", @invoices)
    else
      @invoices
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
    @customer = Customer.find_show(current_account.id, params[:id])
    @invoices = self.invoices
  end



  def new
    @customer = Customer.new
  end

  def edit
    logger.debug(request.method)
  end

  def create
    @customer = Customer.new(params[:customer])
    @customer.account_id = current_account.id

    respond_to do |format|
      if @customer.save
        if params[:referrer_invoice].to_i == 1
          flash[:notice] = "Cliente creado correctamente. Puede crear su Factura"
          format.html { redirect_to(new_customer_invoice_path(@customer))}
        else
          flash[:notice] = "Cliente creado correctamente"
          format.html { redirect_to(@customer)}
          format.js
        end

      else
        params[:error] = true
        format.html { render :action => "new"}
        format.js
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
    @customer = Customer.find(params[:id], :conditions => ["account_id = ?", current_account.id ])
  end

end
