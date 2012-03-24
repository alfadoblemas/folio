class SetDefaultsForCustomer < ActiveRecord::Migration
  def self.up
    clmns = ["address", "city", "industry", "state", "country", "url","phone","fax","alias"]
    clmns.each do |clmn|
      change_column_default :customers, clmn, ""
    end
  end

  def self.down
    clmns = ["address", "city", "industry", "state", "country", "url","phone","fax","alias"]
    clmns.each do |clmn|
      change_column_default :customers, clmn, ""
    end
  end
end