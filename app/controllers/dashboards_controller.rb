class DashboardsController < ApplicationController
  def index
  end

  def show
    @invoices = Invoice.first(:conditions => ["account_id = ?", current_account.id])

    @histories = History.paginate(:page => params[:page], :per_page => 5,
                                  :order => "created_at desc" ,
                                  :conditions => ["account_id = ?", current_account.id])

    if request.xhr?
      render :partial => "histories/history_dashboard", :collection => @histories ,
         :as => :history, :locals => {:continuation => true}
    end
  end

end
