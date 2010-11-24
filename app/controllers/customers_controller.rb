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
        flash[:notice] = "Cliente creado correctamente."
        format.html { redirect_to(@customer)}
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
