class InvoicesController < ApplicationController

  before_filter :find_invoice, :only => [ :active, :cancel, :close, :show, :edit, :destroy, :update_tags ]
  before_filter :sanitize_params, :only => [ :create, :update ]
  before_filter :get_invoices_for_account, :only => [:index, :search]

  def search
    %w(date_gte date_lte).each do |date|
      instance_variable_set("@#{date}", (params[:search][date].blank? ? "" : localize_date(params[:search][date])))
      params[:search][date] = instance_variable_get("@#{date}")
    end

    params[:search][:due_gte] = localize_date(params[:search][:due_gte]) if params[:search][:due_gte]
    params[:search][:due_lte] = localize_date(params[:search][:due_lte]) if params[:search][:due_lte]

    if params[:search][:taxed] == "1" and params[:search][:untaxed] == "0"
      params[:search].delete(:untaxed)
    end

    if params[:search][:taxed] == params[:search][:untaxed]
      params[:search].delete(:untaxed)
      params[:search].delete(:taxed)
    end

    params[:search].delete :customer_name_like unless params[:search][:customer_id_equals].blank?

    @all_invoices = @account_invoices.search(params[:search]).find_by_status(@status)
    @invoices= @all_invoices.paginate(
      :page => params[:page],
      :per_page => 10, :order => @order
    )

    if request.xhr?
      xhr_endless_page_response("invoice", @invoices)
    else
      render :template => "invoices/index"
    end


  end

  def update_tags
    @invoice.tag_list = params[:invoice][:tag_list].to_s
    if @invoice.update_attributes(@invoice.attributes)
      flash.now[:notice] = "La factura no tiene Asunto"
      redirect_to invoice_path(@invoice)
    else
      flash.now[:notice] = "La factura no tiene Asunto"
      format.html { redirect_to(invoice_path(@invoice)) }
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
    # Metodo protegido al final
    @all_invoices = @account_invoices.find_by_status(@status)
    @invoices= @all_invoices.paginate(
      :page => params[:page],
      :per_page => 10, :order => @order
    )

    if request.xhr?
      xhr_endless_page_response("invoice", @invoices)
    end

  end



  def new
    @products = Product.all

    # If a duplicate invoice request
    if params[:id] && params[:duplicate]
      @invoice = Invoice.duplicate(params[:id])
    else
      @invoice = Invoice.new(:account_id => current_account.id)
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
    @invoice.taxed = !@invoice.tax_id.nil?
    @invoice.account_id = current_account.id
    @customer = Customer.find(@invoice.customer_id) unless @invoice.customer_id.blank?
    
    @invoice.invoice_items.each do |item|
      logger.debug("++++++#{item.price}") if item.marked_for_destruction?
    end

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
    @comment = Comment.new()
    @document = Document.new()
    @comment.notify_account_users = @invoice.last_comment_suscriptions[:users]
    @comment.notify_all_account_users = @invoice.last_comment_suscriptions[:all_users]
  end

  def edit
    @invoice.due = @invoice.due_date_to_days
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
    @invoice.taxed = !params[:invoice][:tax_id].blank?
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

    def get_invoices_for_account
      @account_invoices = Invoice.for_account(current_account.id)

      if params[:tagged_with] and !(params[:tagged_with].blank?)
        @account_invoices = @account_invoices.tagged_with(params[:tagged_with])
      end

      @search = Invoice.search(params[:search])
      @status = params[:status].blank? ? "all_invoices" : params[:status]
      order = "#{params[:sort]} #{params[:direction]}"
      @order = order.blank? ? "date desc" : order
      @tags = Invoice.for_account(current_account.id).tag_counts_on(:tags)

    end

    def find_invoice
      @invoice = Invoice.find(params[:id], :conditions => "account_id = #{current_account.id}",
                              :include => [:comments] )
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
      %w(total net).each do |number|
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
