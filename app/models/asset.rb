class Asset < ActiveRecord::Base
  belongs_to :user
  belongs_to :folder
  has_attached_file :uploaded_file, 
  					:default_url => "/images/:style/missing.png",
  					:url => "/assets/get/:id",
               		:path => ":rails_root/assets/:id/:basename.:extension"
end
