class DashboardsController < ApplicationController
  def index
  end

  def show
    last_year_sales = Invoice.year_sales(current_account)
    @months = Invoice.last_12_months.map {|d| "#{d.strftime('%b')}"}
    @invoices = Invoice.first(:conditions => ["account_id = ?", current_account.id])

    @histories = History.paginate(:page => params[:page], :per_page => 5,
                                  :order => "created_at desc" ,
                                  :conditions => ["account_id = ?", current_account.id])

    @year_sales = LazyHighCharts::HighChart.new('chart') do |f|
      f.series( :data => last_year_sales.map {|s| [s[:month], s[:total]]}, :type => 'column')
      
      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:legend][:style] = {}
      f.options[:xAxis] = {:categories => @months }
      f.options[:title] = ""

    end

    if request.xhr?
      sleep(1)
      render :partial => "histories/history_dashboard", :collection => @histories ,
        :as => :history, :locals => {:continuation => true}
    end
  end

end
