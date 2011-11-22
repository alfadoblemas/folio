class IndicadoresEconomicos < ActiveRecord::Base

  SBIF_API_KEY = "42f9540d1e4f1b738f56e93f97a72d5a61b52972"

  def self.for_today
    indicadores = find_by_date(Date.today)
    if indicadores.nil?
      indicadores = get_sbif_data()
      indicadores.save
    elsif indicadores.missing_values?
      indicadores.missing_values.each do |missing|
        missing_value = get_sbif_value(missing)
        indicadores.send("#{missing}=",missing_value)
      end
      indicadores.save
      indicadores.missing_values.each do |missing|
        indicadores_yesterday = find_by_date(Date.yesterday)
        indicadores.send("#{missing}=",indicadores_yesterday.send(missing))
      end
    end
    indicadores
  end

  def missing_values?
    uf.nil? || dolar.nil? || utm.nil? || euro.nil?
  end

  def missing_values
    missing = []
    %w(uf dolar utm euro).each do |indicator|
      missing << indicator if self.send(indicator).nil?
    end
    missing
  end

  private
    def self.get_sbif_data
      sbif = SBIF.new(:api_key => SBIF_API_KEY)
      indicadores_economicos = self.new(
        :uf => sbif.uf,
        :utm => sbif.utm,
        :dolar => sbif.dolar,
        :euro => sbif.euro,
      :date => Date.today)
    end

    def self.get_sbif_value(indicador)
      sbif = SBIF.new(:api_key => SBIF_API_KEY)
      sbif.send(indicador)
    end



end
