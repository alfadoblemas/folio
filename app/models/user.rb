class User < ActiveRecord::Base

  #Assoc
  belongs_to :account
  has_many :histories

  acts_as_authentic do |c|
    c.validations_scope = :account_id
  end


end
