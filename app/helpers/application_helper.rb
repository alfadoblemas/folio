# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def labelUp_tag(text)
    "<label for=\"#{text}\">#{text.upcase}</label>"
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association, locals={})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "_replaceme_") do |builder|
      render(association.to_s.singularize + "_fields", locals.merge!(:f => builder))
    end
    link_to_function(name, h("add_fields(this,\"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def sortable(title = nil, state = nil)
    if params[:sort]
      direction = params[:direction] == "desc" ? "asc" : "desc"
      link_to title, params.merge(:direction => direction), {:class => "#{direction} image_link"}
    end
  end
  
  def sortable2(title = nil, state = nil)
     if params[:sort]
       direction = params[:direction] == "desc" ? "asc" : "desc"
       link_to title, params.merge(:direction => direction, :sort => params[:sort]), {:class => "#{direction} image_link"}, :method => :post
     end
   end

  def link_from_comment(comment, title = nil)
    invoice = comment.invoice
    customer = invoice.customer
    customer_name = customer.alias.blank? ? customer.name : customer.alias
    link_to "##{invoice.number}: #{invoice.subject}", invoice_path(comment.invoice_id),
      :title => "#{customer_name}\n #{invoice.subject}"
  end

  def invoice_state_link(state, title = nil, status_id = nil)
    params[:status] == state ? "#{title} " : (link_to "#{title} ", params.merge(:status => state))
  end

  def textarea_display(text)
    text.gsub(/\n/, "<br/>")
  end

  def title(page_title)
    content_for(:title) { page_title}
  end

  def pageless(total_pages, url=nil, parent_container=nil, container=nil)
    opts = {
      :totalPages => total_pages,
      :url        => url,
      :loaderMsg  => 'Cargando más resultados',
      :parent_container => parent_container,
      :distance => 200,
      :params => params
    }

    container && opts[:container] ||= container

    javascript_tag("$('#{container}').pageless(#{opts.to_json});")
  end

  def select_box_sorter()
    if params[:status].nil? || params[:status] == "draft"
      options = Invoice.sorter_options("active")
    else
      options = Invoice.sorter_options(params[:status])
    end
    select_tag(:sort, options_for_select(options.sort, params[:sort]), { :onchange => "this.form.submit();"})
  end

end

def sidebar_big_button(action, object, title)
  if action == "submit"
    path = "new_#{object}_path"
  else
    path = "#{object.pluralize}_path"
  end
  url = "location.href='"+eval(path)+"'"
  content_tag :div, :class => "big_button", :onclick => url do
    link_to title, eval(path), :class => "#{action}_action"
  end
end

def number_to_chilean_currency(number)
  number_to_currency(number, :unit => "$", :delimiter => ".", :precision => 0)
end

def link_to_invoices_due_this_week
    link_to "Ver más", search_invoice_path({:sort => "due", :search => 
      {:due_gte => Date.today.beginning_of_week, :due_lte => Date.today.end_of_week, :status_id => 2}
      })
end