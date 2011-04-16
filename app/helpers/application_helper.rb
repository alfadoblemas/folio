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

  def sortable(column, title = nil, state = nil)
    title ||= column.titleize
    css_class = (column == params[:sort]) ? "current #{params[:direction]} sortLink" : "sortLink"
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction), {:class => css_class}
  end

  def link_from_comment(comment, title = nil)
    link_to "#{comment.invoice.customer.name} - #{title}: #{comment.invoice.subject}", invoice_path(comment.invoice_id),
      :title => "#{comment.invoice.customer.name}\n #{comment.invoice.subject}"
  end

  def invoice_state_link(state, title = nil, status_id = nil)
    if params[:action] == "search"
      params[:status] == state ? "#{title} " : (link_to "#{title} ", params.merge(:status => state))
    else
      params[:status] == state ? "#{title} " : (link_to "#{title} ", params.merge(:status => state))
    end
  end

  def textarea_display(text)
    text.gsub(/\n/, "<br />")
  end

  def title(page_title)
    content_for(:title) { page_title}
  end

end
