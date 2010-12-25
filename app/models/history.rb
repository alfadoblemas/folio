class History < ActiveRecord::Base

  validates_presence_of :comment, :invoice_id

  belongs_to :invoice

end
