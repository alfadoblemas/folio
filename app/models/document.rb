class Document < ActiveRecord::Base
  before_save :randomize_file_name
  belongs_to :invoice
  belongs_to :user
  belongs_to :account

  # :account_id se define en el archivo config/initializers/paperclip.rb
  has_attached_file :attachment,
    :url => '/:class/:id/:filename',
    :path => ':rails_root/uploads/:class/:account_id/:id_partition/:filename'

  validates_attachment_presence :attachment
  #validates_attachment_content_type :attachment, :content_type => 
  validates_attachment_size :attachment, :less_than => 10.megabytes
  
  def user_name
    user.name
  end
  
  def attachment_extension
    File.extname(attachment_file_name)
  end
  
  def attachment_url
    "/documents/#{id}/#{original_file_name}"
  end
  
  def original_file_name
    read_attribute("original_file_name").nil? ? attachment_file_name : read_attribute("original_file_name")
  end
  
  private
  def randomize_file_name
    return if attachment_file_name.nil?
    extension = File.extname(attachment_file_name).downcase
    if attachment_file_name_changed?
      self.original_file_name = attachment_file_name
      self.attachment.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
    end
  end

end
