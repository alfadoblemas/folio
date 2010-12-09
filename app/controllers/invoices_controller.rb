class InvoicesController < ApplicationController
  def index
    # borrador
    @invoices_draft = Invoice.find(:all, :conditions => "status_id == 1")

    # abiertas
    @invoices_open = Invoice.find(:all, :conditions => "status_id == 2")
  end

  def new
    @invoice = Invoice.new
    @invoice.invoice_items.build
    @products = Product.find(:all).map { |product| [product.name, product.id.to_i] }
    if !params[:customer_id].nil?
      @customer = Customer.find(params[:customer_id])
    else
      @customer = Customer.new
    end
    @product_selected = [1]
  end


  def create

    unformat_prices(params)

    @invoice = Invoice.new(params[:invoice])
    @customer = Customer.find(@invoice.customer_id) unless @invoice.customer_id.nil?
    @products = Product.find(:all).map { |product| [product.name, product.id.to_i] }
    
    logger.debug("Aqui")
    logger.debug(@invoice.invoice_items[0].product_id.class)

    params[:invoice][:invoice_items_attributes].each_key do |key|
      unless params[:invoice][:invoice_items_attributes][key].blank?
        params[:invoice][:invoice_items_attributes].delete(key)
      end
    end

    
    respond_to do |format|
      if @invoice.save
        flash[:notice] = "Factura creada correctamente."
        format.html { redirect_to(@invoice)}
      else
        @customer = @customer.nil? ? Customer.new : @customer
        format.html { render :action => "new"}
      end
    end
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def edit
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_path) }
      format.xml  { head :ok }
    end
  end

  def update
  end

  protected
  def currency_to_number(price)
    price.scan(/\d+/).join.to_i
  end

  def unformat_prices(params)
    params[:invoice][:tax] = currency_to_number(params[:invoice][:tax])
    params[:invoice][:total] = currency_to_number(params[:invoice][:total])
    params[:invoice][:net] = currency_to_number(params[:invoice][:net])

    params[:invoice][:invoice_items_attributes].each_key do |key|
      params[:invoice][:invoice_items_attributes][key][:price] = currency_to_number(params[:invoice][:invoice_items_attributes][key][:price])
      params[:invoice][:invoice_items_attributes][key][:total] = currency_to_number(params[:invoice][:invoice_items_attributes][key][:total])
      params[:invoice][:invoice_items_attributes][key][:product_id] = params[:invoice][:invoice_items_attributes][key][:product_id].to_i
    end
    params
  end


  def get_customer_info(params)
    
  end


end
