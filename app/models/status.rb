class Status < ActiveRecord::Base

  has_many :invoices

  def self.name_by_state(state)
    state = "open" if state == "active"
    state = "close" if state == "close_index"
    find_by_state(state).name.titleize.pluralize
  end

end
