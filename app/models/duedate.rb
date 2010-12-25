
class Duedate

  attr_accessor :value, :text

  def initialize(value, text)
    self.value = value.to_i
    self.text = text
  end

end
