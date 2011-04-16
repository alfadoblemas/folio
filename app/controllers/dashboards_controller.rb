class DashboardsController < ApplicationController
  def index
  end

  def show
    @invoices = Invoice.first(:conditions => ["account_id = ?", current_account.id])
    
    @histories = History.paginate(:page => 1, :per_page => 5,
                                  :order => "created_at desc" ,
                                  :conditions => ["account_id = ?", current_account.id])
  end

end
