module Tools
  
  def self.last_months_from_today(months_ago)
    months = Array.new
    (0..months_ago - 1).each do |m|
      months << Date.today.months_ago(m)
    end
    months.reverse
  end
  
end