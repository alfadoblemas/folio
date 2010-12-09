class Product < ActiveRecord::Base

  has_many :invoice_items


 private

 def attributes_protected_by_default
   []
 end

end
