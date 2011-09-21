module InvoicesHelper
  
  def print_tag_list(invoice)
    invoice.ordered_tag_list.join(", ")
  end
end
