class TaxesController < ApplicationController

  def index
    @taxes = Tax.find_all_by_account_id(current_account.id, :select => 'id, name, value')
    respond_to do |format|
      format.json {render :json => @taxes.to_json}
    end
  end
  
  def show
    @tax = Tax.find(params[:id], :conditions => "account_id == #{current_account.id}")
    respond_to do |format|
      format.js {render :json => @tax.to_json}
    end
  end

  def create
    @tax = Tax.new(params[:tax])
    respond_to do |format|
      if @tax.save
        flash[:notice] = "Impuesto agregado."
        format.html { redirect_to(@tax.account)}
        format.js
      else
        format.html {redirect_to(current_account)}
        format.js
      end
    end
  end

  def destroy
    @tax = Tax.find(params[:id])
    respond_to do |format|
      if @tax.destroy
        format.html do
          flash[:notice] = "Impuesto eliminado"
          redirect_to(@tax.account)
        end
        format.js
      else
        format.html {redirect_to(@tax.account)}
      end
    end
  end

end
