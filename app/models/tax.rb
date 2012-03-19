class Tax < ActiveRecord::Base
  belongs_to :account
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  validates_numericality_of :value, :on => :create, :message => "is not a number"
  
  def self.find_for_account_in_json(account_id)
    taxes = find_all_by_account_id(account_id, :select => 'id, name, value')
    hash_for_json = Hash.new
    taxes.each do |tax|
      hash_for_json[tax.id.to_s] = [tax.name, tax.value]
    end
    hash_for_json
  end
  
end
