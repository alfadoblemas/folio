# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def labelUp_tag(text)
    "<label for=\"#{text}\">#{text.upcase}</label>"
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "_replaceme_") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this,\"#{association}\", \"#{escape_javascript(fields)}\")"))
  end
  
  def sortable(column, title = nil, state = nil)
    title ||= column.titleize
    css_class = (column == params[:sort]) ? "current #{params[:direction]} sortLink" : "sortLink"
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    if state == params[:status]
      link_to title, params.merge(:sort => column, :direction => direction, :status => state, :anchor => state),
      {:class => css_class}
    else
      link_to title,  params.merge(:sort => column, :direction => direction, :status => state, :anchor => state ),
      {:class => "sortLink"}
    end
  end
  
  def textarea_display(text)
    text.gsub(/\n/, "<br />")
  end

end
