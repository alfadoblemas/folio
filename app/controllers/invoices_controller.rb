class InvoicesController < ApplicationController
  def index
  end

  def new
    @invoice = Invoice.new
    @invoice.invoice_items.build
  end

  def show
  end

  def edit
  end

  def destroy
  end

  def update
  end

end
