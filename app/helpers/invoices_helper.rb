module InvoicesHelper
  include ActsAsTaggableOn::TagsHelper
  
  def print_tag_list(invoice)
    invoice.ordered_tag_list.join(", ")
  end
  
  def dates_in_invoice_model
    [["Emición", "date"], ["Vencimiento", "due"], ["Pago", "close_date"]]
  end
  
  def sets_visibility_of_element(flag)
    return "display:none;" unless flag
  end
  
end
