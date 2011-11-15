class IndicadoresEconomicos
  
  API_KEY = "42f9540d1e4f1b738f56e93f97a72d5a61b52972"
  
  attr_reader :uf, :dolar, :utm, :euro
  
  def initialize
    sbif = SBIF.new(:api_key => API_KEY)
    @uf = sbif.uf
    @dolar = sbif.dolar
    @utm = sbif.utm
    @euro = sbif.euro
  end
  
end