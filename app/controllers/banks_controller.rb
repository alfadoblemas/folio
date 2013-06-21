class BanksController < ApplicationController
  before_filter :sidebar?
  
  
  def index
    
  end
  
  private
  def sidebar?
    @no_sidebar = true
  end
  
end
