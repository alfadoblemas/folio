class ExpensesController < ApplicationController
  before_filter :find_expense, :only => [ :active, :cancel, :close, :show, :edit, :destroy ]
  before_filter :sanitize_params_on_change, :only => [ :create, :update ]
  
  def attachment
    @expense = Expense.find(params[:id])
    send_file @expense.attachment.path
  end
  
  def index
    @search = Expense.search(params[:search])
    @status = params[:status].blank? ? ["all_index", current_account.id] : [params[:status], current_account.id]
    payment_method = params[:payment_method].blank? ? 0 : params[:payment_method].to_i
    order = "#{params[:sort]} #{params[:direction]}"
    if payment_method == 0
      @expenses = Expense.find_by_status(@status, params[:page], order ,current_account.id)
    else
      @expenses = Expense.by_payment_method(payment_method).find_by_status(@status, params[:page], order ,current_account.id)
    end

    if request.xhr?
      xhr_endless_page_response({:partial => "expense", :collection => @expenses})
    end
  end

  def show
  end

  def new
    @expense = Expense.new

    if @expense.vendor_id
      @vendor = Expense.find(@expense.vendor_id)
    elsif params[:vendor_id]
      @vendor = Vendor.find(params[:vendor_id])
    else
      @vendor = Customer.new
    end

  end

  def edit
    @vendor = Customer.find(@expense.vendor_id)
  end

  def create
    @expense = Expense.new(params[:expense])
    @expense.account_id = current_account.id
    @expense.user_id = current_user.id
    @vendor = Customer.find(@expense.vendor_id) unless @expense.vendor_id.blank?

    respond_to do |format|
      if @expense.save
        flash[:notice] = "Gasto creado correctamente."
        format.html { redirect_to(@expense)}
      else
        @vendor = Customer.new unless defined?(@vendor)
        format.html { render :action => "new"}
      end
    end
  end

  def destroy
  end

  def update
    @expense = Expense.find(params[:id])
    @vendor = Customer.find(@expense.vendor_id)
    
    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        flash[:notice] = "Gasto actualizado"
        format.html {redirect_to(expenses_path)}
      else
        format.html {render :action => "edit"}
      end
    end
    
  end

  protected

    def find_expense
      @expense = Expense.find(params[:id], :conditions => "account_id = #{current_account.id}")
    end
    
    def sanitize_params_on_change
      params[:expense][:total] = currency_to_number(params[:expense][:total])
      params[:expense][:due_date] = localize_date(params[:expense][:due_date]).to_date rescue ""
    end

end
