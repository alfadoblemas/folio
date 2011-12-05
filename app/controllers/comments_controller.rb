class CommentsController < ApplicationController

  def create
    params[:comment][:notify_account_users] = params[:comment][:notify_account_users].keys.join(",")
    @comment = Comment.new(params[:comment])
    @invoice = Invoice.find(@comment.invoice_id)

    respond_to do |format|
      if @comment.save
        flash[:notice] = "Comentario agregado."
        format.html { redirect_to(@invoice)}
      else
        format.html { redirect_to(@invoice)}
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @invoice = Invoice.find(@comment.invoice_id)
    if created_by_current_user?(@comment)
      @comment.destroy

      respond_to do |format|
        format.html { redirect_to(invoice_path(@invoice)) }
        format.xml  { head :ok }
      end
    else
      redirect_to(@invoice)
    end
  end

end
