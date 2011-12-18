class Document < ActiveRecord::Base
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

end
