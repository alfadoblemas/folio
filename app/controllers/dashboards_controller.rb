class DashboardsController < ApplicationController
  def index
  end

  def show

    @account = Account.find(current_account)
    last_year_sales = @account.monthly_sales_agregate()
    @months = Tools::last_months_from_today(12).map {|d| "#{I18n.localize(d, :format => :month_abbr)}"}

    @comments = Comment.find_for_dashboard(:account => current_account, :page => params[:page])

    @year_sales = LazyHighCharts::HighChart.new('chart') do |f|
      f.series( :data => last_year_sales.map {|s| [s[:month], s[:service_sales]]}, :type => 'column', :name => "Servicios")
      f.series( :data => last_year_sales.map {|s| [s[:month], s[:commodity_sales]]}, :type => 'column', :name => "Productos")
      f.series( :data => last_year_sales.map {|s| [s[:month], s[:tax_difference]]}, :type => 'column', :name => "Impuestos")

      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:legend][:style] = {}
      f.options[:xAxis] = {:categories => @months }
      f.options[:title] = ""
      f.options[:plotOptions][:column] = {:events => {:click => ""}}
      f.options[:plotOptions][:column][:stacking] = 'normal'


    if request.xhr?
      render :partial => "comments/comment_dashboard", :collection => @comments ,
        :as => :comment, :locals => {:continuation => true}
    end
      
    end
    
  end

end
