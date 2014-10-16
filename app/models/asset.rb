class Asset < ActiveRecord::Base
  belongs_to :user
  has_attached_file :uploaded_file, 
  					:default_url => "/images/:style/missing.png",
  					:url => "/assets/get/:id",
               		:path => ":rails_root/assets/:id/:basename.:extension"
  do_not_validate_attachment_file_type :uploaded_file
  validates_with AttachmentSizeValidator, :attributes => :uploaded_file, :less_than => 10.megabytes
  validates_with AttachmentPresenceValidator, :attributes => :uploaded_file
end
