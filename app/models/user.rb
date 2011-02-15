class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validations_scope = :account_id
  end
  
  #Assoc
  belongs_to :account
  
end
