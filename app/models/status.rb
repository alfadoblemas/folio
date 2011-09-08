class Status < ActiveRecord::Base

  has_many :invoices
  has_many :expenses


  def attributes_protected_by_default
   []
  end

end
