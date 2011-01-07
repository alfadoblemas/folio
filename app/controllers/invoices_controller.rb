class InvoicesController < ApplicationController

  def active
    @invoice = Invoice.find(params[:id])
    unless @invoice.status_id == 2
      due_days = ((@invoice.due.to_time - @invoice.date.to_time)/3600/24).to_i

      @history = History.new(:subject => "Activación", :comment => "Factura activada",
                             :invoice_id => @invoice.id)

      respond_to do |format|
        if @invoice.number
          @invoice.update_attribute(:status_id, 2)
          @invoice.update_attribute(:date, Date.today)
          due_date = @invoice.date.to_date.advance(:days => due_days)
          @invoice.update_attribute(:due, due_date)
          @history.save
          flash[:notice] = "Factura activada."
          format.html { redirect_to(invoice_path(@invoice)) }
        else
          @customer = Customer.find(@invoice.customer_id)
          @invoice.status_id = 2
          flash.now[:notice] = "La factura debe tener un número"
          format.html { render :action => "edit" }
        end
      end
    else
      respond_to do |format|
        flash[:notice] = "La Factura ya está activa"
        format.html { redirect_to(invoice_path(@invoice)) }
      end 
    end
  end

  def deactive
    @invoice = Invoice.find(params[:id])
    @history = History.new(:subject => "Borrador", :comment => "La factura cambio estado a borrador",
                           :invoice_id => @invoice.id)

    respond_to do |format|
      if @invoice.update_attribute(:status_id, 1)
        @history.save
        flash[:notice] = "Factura actualizada"
        format.html { redirect_to(invoice_path(@invoice))}
      end

    end
  end

  def close

    @invoice = Invoice.find(params[:id])

    @history = History.new(:subject => "Pagada", :comment => "Factura pagada",
                           :invoice_id => @invoice.id)

    respond_to do |format|
      if @invoice.update_attribute(:status_id, 3)
        @invoice.update_attribute(:close_date, Date.today)
        @history.save
        flash[:notice] = "Factura pagada"
        format.html { redirect_to(invoice_path(@invoice)) }
      end
    end
  end

  def index

    if params[:search] && !params[:search].blank?
      @invoices = Invoice.search(params[:search])
    elsif

      # vermos si hay facturas
      @invoices = Invoice.find(:first)

      invoice_kinds = Invoice.kinds.map {|v| v[:kind] }
      invoice_kinds.each do |kind|
        result = Invoice.method("find_#{kind}")
        instance_variable_set("@invoices_#{kind}", result.call(params[:sort],params[:direction]))
      end
    end

  end

  def new

    if params[:id] && params[:duplicate]
      @invoice_new = Invoice.find(params[:id])
      @invoice_new.date = Date.today
      @invoice_new.number = ""
      @invoice_new.status_id = 1
      @invoice = @invoice_new.clone()

      @invoice_new.invoice_items.each_with_index do |line, index|
        @invoice.invoice_items[index]=line.clone()
      end

    else
      @invoice = Invoice.new
      @invoice.invoice_items.build
    end



    if @invoice.customer_id
      @customer = Customer.find(@invoice.customer_id)
    elsif !params[:customer_id].nil?
      @customer = Customer.find(params[:customer_id])
    else
      @customer = Customer.new
    end

  end


  def create

    # En caso que no se guarde, guardamos los días para renderizar la form.
    due_date = params[:invoice][:due].to_i

    # Convertimos precios a numeros
    unformat_prices(params)

    @invoice = Invoice.new(params[:invoice])
    @customer = Customer.find(@invoice.customer_id) unless @invoice.customer_id.nil?

    @invoice.due = @invoice.date.to_date.advance(:days => due_date)

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
        @invoice.due = due_date
        format.html { render :action => "new"}
      end
    end
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def edit
    @invoice = Invoice.find(params[:id])
    due_days = ((@invoice.due.to_time - @invoice.date.to_time)/3600/24).to_i
    @invoice.due = due_days
    @customer = Customer.find(@invoice.customer_id)
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      flash[:notice] = "Factura #{@invoice.number} eliminada"
      format.html { redirect_to(invoices_path) }
      format.xml  { head :ok }
    end
  end

  def update
    unformat_prices(params)
    due_date = params[:invoice][:due].to_i

    @invoice = Invoice.find(params[:id])

    if @invoice.status_id == 2
      params[:invoice][:status_id] = 2
    end

    @customer = Customer.find(@invoice.customer_id)

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        due_date = @invoice.date.to_date.advance(:days => due_date)
        @invoice.update_attribute(:due, due_date)
        format.html { redirect_to(invoice_path(@invoice), :ice => 'Factura actualizada.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
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
