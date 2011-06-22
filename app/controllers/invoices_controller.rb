class InvoicesController < ApplicationController

  before_filter :find_invoice, :only => [ :active, :cancel, :close, :show, :edit, :destroy ]
  before_filter :sanitize_params, :only => [ :create, :update ]

  def search
    %w(date_gte date_lte).each do |date|
      instance_variable_set("@#{date}", (params[:search][date].blank? ? "" : localize_date(params[:search][date])))
      params[:search][date] = instance_variable_get("@#{date}")
    end
    
    if params[:search][:taxed] == "1" and params[:search][:untaxed] == "0"
      params[:search].delete(:untaxed)
    end
    
    if params[:search][:taxed] == params[:search][:untaxed]
      params[:search].delete(:untaxed)
      params[:search].delete(:taxed)
    end

    @search = Invoice.search(params[:search])
    @status = params[:status].blank? ? "all_invoices" : params[:status]
    order = "#{params[:sort]} #{params[:direction]}"
    @invoices = @search.find_by_status(@status, params[:page], order, current_account.id ,params[:per_page], false)

    if request.xhr?
      xhr_endless_page_response
    else
      render :template => "invoices/index"
    end


  end


  def active
    respond_to do |format|
      if @invoice.number
        @invoice.active!(current_user)
        flash[:notice] = "Factura activada."
        format.html { redirect_to(invoice_path(@invoice)) }
      else
        @customer = Customer.find(@invoice.customer_id)
        flash.now[:notice] = "La factura debe tener un número"
        format.html { render :action => "edit" }
      end
    end
  end


  def cancel
    respond_to do |format|
      @invoice.cancel!(current_user)
      flash[:notice] = "Factura Anulada"
      format.html { redirect_to(invoice_path(@invoice))}
    end
  end

  def close
    respond_to do |format|
      if @invoice.close!(current_user)
        flash[:notice] = "Factura pagada"
        format.html { redirect_to(invoice_path(@invoice)) }
      end
    end
  end



  def index
    @search = Invoice.search(params[:search])
    @status = params[:status].blank? ? "all_invoices" : params[:status]
    order = "#{params[:sort]} #{params[:direction]}"
    @invoices = Invoice.find_by_status(@status, params[:page], order ,current_account.id)

    if request.xhr?
      xhr_endless_page_response
    end

  end



  def new
    @products = Product.all

    # If a duplicate invoice request
    if params[:id] && params[:duplicate]
      @invoice = Invoice.duplicate(params[:id])
    else
      @invoice = Invoice.new
      @invoice.invoice_items.build
    end

    if @invoice.customer_id
      @customer = Customer.find(@invoice.customer_id)
    elsif params[:customer_id]
      @customer = Customer.find(params[:customer_id])
    else
      @customer = Customer.new
    end

  end


  def create
    @invoice = Invoice.new(params[:invoice])
    @invoice.account_id = current_account.id
    @customer = Customer.find(@invoice.customer_id) unless @invoice.customer_id.blank?

    #TODO: No me acuerdo que hace
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
        @customer = Customer.new unless defined?(@customer)
        @invoice.due = params[:due_date]
        @products = Product.all
        @search = Invoice.search(params[:search])
        format.html { render :action => "new"}
      end
    end
  end

  def show
  end

  def edit
    due_days = ((@invoice.due.to_time - @invoice.date.to_time)/3600/24).to_i
    @invoice.due = due_days
    @customer = Customer.find(@invoice.customer_id)
    @products = Product.all
  end

  def destroy
    @invoice.destroy

    respond_to do |format|
      flash[:notice] = "Factura #{@invoice.number} eliminada"
      format.html { redirect_to(invoices_path) }
      format.xml  { head :ok }
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    @customer = Customer.find(@invoice.customer_id)

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        flash[:notice] = 'Factura actualizada.'
        format.html { redirect_to(invoice_path(@invoice)) }
        format.xml  { head :ok }
      else
        @products = Product.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  protected

    def xhr_endless_page_response
      sleep(1)
      render :partial => "invoice", :collection => @invoices, :locals => {:continuation => true}
    end

    def find_invoice
      @invoice = Invoice.find(params[:id], :conditions => "account_id = #{current_account.id}",
                              :include => [:histories] )
    end

    def sanitize_params
      # En caso que no se guarde, guardamos los días para renderizar la form.
      params[:due_date] = params[:invoice][:due].to_i
      date = localize_date(params[:invoice][:date]).to_date rescue ""
      params[:invoice][:date] = date
      params[:invoice][:due] = date.to_date.advance(:days => params[:due_date]) unless date.blank?

      # Convertimos precios a numeros
      unformat_prices(params)
    end

    def currency_to_number(price)
      price.scan(/\d+/).join.to_i
    end

    def unformat_prices(params)
      %w(tax total net).each do |number|
        params[:invoice][number.to_sym] = currency_to_number(params[:invoice][number.to_sym])
      end

      params[:invoice][:invoice_items_attributes].each_key do |key|
        %w(price total product_id).each do |number|
          params[:invoice][:invoice_items_attributes][key][number.to_sym] = currency_to_number(params[:invoice][:invoice_items_attributes][key][number.to_sym])
        end
      end
      params
    end

    def localize_date(date)
      tmp = date.split(/\/|-/)
      date = "#{tmp[2]}-#{tmp[1]}-#{tmp[0]}"
      date
    end

end
