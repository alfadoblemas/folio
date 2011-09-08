module FolioExtraHelpers

  def currency_to_number(price)
    price.scan(/\d+/).join.to_i
  end

  def xhr_endless_page_response(options)
    sleep(1)
    render :partial => options[:partial], :collection => options[:collection],
      :locals => {:continuation => true}
  end

  def localize_date(date)
    tmp = date.split(/\/|-/)
    date = "#{tmp[2]}-#{tmp[1]}-#{tmp[0]}"
    date
  end

end
