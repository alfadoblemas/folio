class CreateIndicadoresEconomicos < ActiveRecord::Migration
  def self.up
    create_table :indicadores_economicos do |t|
      t.date :date
      t.float :uf
      t.float :dolar
      t.float :utm
      t.float :euro

      t.timestamps
    end
    
    add_index :indicadores_economicos, :date, :name => 'indicadores_econcomicos_date_index'
  end

  def self.down
    drop_table :indicadores_economicos
  end
end
