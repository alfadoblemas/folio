class CustomersController < ApplicationController
  auto_complete_for :customers, :name

  def search
    unless params[:q].nil?
      @customers = Customer.find(:all, :conditions => ['name LIKE ?',
                                                       "%#{params[:q]}%"])
    end

    respond_to do |format|
      format.xml { render :xml => @customers}
      format.json { render :json => @customers}
    end

  end

  def index
    @customers = Customer.find_index
    @customer_alphabetical = Customer.alphabetical_group(params[:letter])
    respond_to do |format|
      format.html
    end
  end
  

  def show
    @customer = Customer.find(params[:id])
    if params[:sort]
      @invoices = Invoice.paginate(:conditions => "customer_id = #{@customer.id}", :page => params[:page],
                                  :per_page => 10, :order => ["#{params[:sort]} #{params[:direction]}" ] )
    else
      @invoices = Invoice.paginate(:conditions => "customer_id = #{@customer.id}", :page => params[:page],
                                  :per_page => 10, :order => 'date desc')
    end
                              
  

  end

  def new
    # TODO: Falta mejorar la información de errores
    @customer = Customer.new
  end

  def edit
    @customer = Customer.find(params[:id])
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
    @customer = Customer.find(params[:id])
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
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      flash[:notice] = "Cliente #{@customer.name} eliminado"
      format.html { redirect_to(customers_path) }
      format.xml  { head :ok }
    end
  end

end
