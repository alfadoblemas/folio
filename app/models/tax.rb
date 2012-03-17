class Tax < ActiveRecord::Base
  belongs_to :account
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  validates_numericality_of :value, :on => :create, :message => "is not a number"
  
end
