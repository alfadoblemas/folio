module DocumentsHelper
  
  def document_icon_tag(extension)
    extension = extension.upcase.delete(".")
    icons = %( DOC MP3 ODS ODT PDF PNG PPT TXT XLS )
    if icons.include?(extension.upcase)
      image_tag "icons/icon_#{extension.upcase}_big.png"
    else
      image_tag "icons/icon_Generic_big.png"
    end
  end
  
end
