class CommentsController < ApplicationController

  def new
    @invoice = Invoice.find(params[:invoice_id])
    @comment = Comment.new()
  end

  def create
    @comment = Comment.new(:subject => params[:subject], :body => params[:body],
                           :invoice_id => params[:invoice_id], :user_id => params[:user_id], :account_id => current_account.id,
                           :comment_type_id => 1)
    @invoice = Invoice.find(params[:invoice_id])

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
