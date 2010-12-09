class Status < ActiveRecord::Base

  has_many :invoices


  def attributes_protected_by_default
   []
  end

end
