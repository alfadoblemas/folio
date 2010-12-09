class CustomersController < ApplicationController

  def index
    # TODO: Falta agreagar paginación y ordenamiento
    @customers = Customer.find_index
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def new
    # TODO: Falta mejorar la información de errores
    @customer = Customer.new
    @customer.contacts.build
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        if params[:referrer_invoice]
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

end
