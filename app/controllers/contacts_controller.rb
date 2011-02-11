class ContactsController < ApplicationController
  
  before_filter :find_contact, :only => [:show, :edit, :update, :destroy]
  before_filter :contact_customer, :only => [:edit, :destroy]
  
  
  # GET /contacts
  # GET /contacts.xml
  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @customer = Customer.find(params[:customer_id])
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit

  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = Contact.new(params[:contact])
    @customer = Customer.find(@contact.customer_id)

    respond_to do |format|
      if @contact.save
        flash[:notice] = "Contacto creado correctamente."
        format.html { redirect_to(@customer)}
      else
        format.html { render :action => "new"}
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @customer = Customer.find(@contact.customer_id)

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(customer_path(@contact.customer_id), :notice => 'Contacto actualizado.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy

    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(customer_path(@customer)) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def contact_customer
    @customer = @contact.customer
  end
  
  def find_contact
    @contact = Contact.find(params[:id])
  end
  
end
