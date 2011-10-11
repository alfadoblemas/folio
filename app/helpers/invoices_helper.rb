module InvoicesHelper
  
  def print_tag_list(invoice)
    invoice.ordered_tag_list.join(", ")
  end
  
  def dates_in_invoice_model
    [["Emición", "date"], ["Vencimiento", "due"], ["Pago", "close_date"]]
  end
  
end
