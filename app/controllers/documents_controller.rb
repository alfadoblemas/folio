class DocumentsController < ApplicationController

  SEND_FILE_METHOD = :default

  def download
    head(:not_found) and return if (document = Document.find_by_id(params[:id])).nil?
    #head(:forbidden) and return unless track.downloadable?(current_user)

    path = document.attachment.path()
    head(:bad_request) and return unless File.exist?(path)

    send_file_options = { :type => document.attachment.content_type, :filename => document.original_file_name }

    #case SEND_FILE_METHOD
    #when :apache then send_file_options[:x_sendfile] = true
    #when :nginx then head(:x_accel_redirect => path.gsub(Rails.root, ''), :content_type => send_file_options[:type]) and return
    #end

    send_file(path, send_file_options)
  end


  def create
    @document = Document.new(params[:document])

    respond_to do |format|
      if @document.save
        flash[:notice] = "Archivo agregado"
        # :anchor is for selecting the files tab after saving the file
        format.html {redirect_to(invoice_path(@document.invoice_id, :anchor => "tabs-2"))}
      else
        flash[:notice] = "No fue posible agregar el archivo"
        format.html {redirect_to(invoice_path(@document.invoice_id))}
      end
    end

  end

  def destroy
    @document = Document.find(params[:id])
    invoice = @document.invoice
    respond_to do |format|
      if @document.destroy
        flash[:notice] = "Archivo eliminado correctamente"
        format.html {redirect_to(invoice_path(invoice))}
      else
        flash[:notice] = "No fue posible eliminar el archivo"
        format.html {redirect_to(invoice_path(invoice))}
      end
    end
  end

end
