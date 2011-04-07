class HistoriesController < ApplicationController

  def new
    @invoice = Invoice.find(params[:invoice_id])
    @history = History.new()
  end

  def create
    @history = History.new(:subject => params[:subject], :comment => params[:comment],
                           :invoice_id => params[:invoice_id], :user_id => params[:user_id], :account_id => current_account.id,
                           :history_type_id => 1)
    @invoice = Invoice.find(params[:invoice_id])

    respond_to do |format|
      if @history.save
        flash[:notice] = "Comentario agregado."
        format.html { redirect_to(@invoice)}
      else
        format.html { redirect_to(@invoice)}
      end
    end
  end

  def destroy
    @history = History.find(params[:id])
    @invoice = Invoice.find(@history.invoice_id)
    if created_by_current_user?(@history)
      @history.destroy

      respond_to do |format|
        format.html { redirect_to(invoice_path(@invoice)) }
        format.xml  { head :ok }
      end
    else
      redirect_to(@invoice)
    end
  end

end
