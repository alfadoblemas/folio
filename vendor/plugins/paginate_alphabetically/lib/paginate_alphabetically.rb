module PaginateAlphabetically
  def paginate_alphabetically(params)
    @attribute = params[:by]
    self.extend ClassMethods
  end

  module ClassMethods
    def pagination_letters(current_account)
      find(:all, :conditions => ["account_id = ?", current_account.id]).sort_by{|obj| obj.send(@attribute).upcase}.group_by {|group| group.send(@attribute)[0].chr.upcase}.keys
    end

    def first_letter
      first_instance = find(:first, :order => @attribute, :conditions => ["#{@attribute.to_s} >= ?", 'a'])
      return 'A' if first_instance.nil?
      first_instance.send(@attribute)[0].chr.upcase
    end

    def alphabetical_group(account, letter = nil)
      find(:all, :conditions => ["account_id = ? and #{@attribute.to_s} LIKE ?", "#{account}","#{letter || first_letter}%"], :order => @attribute)
    end
  end
end
