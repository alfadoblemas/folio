class AddUniqToTaxName < ActiveRecord::Migration
  def self.up
    change_column_default :taxes, :value, 0
  end

  def self.down
    change_column_default :taxes, :value, 0
  end
end