class Asset < ActiveRecord::Base
	belongs_to :profile

 has_attached_file :photo,:url => "/system/:attachment/:id/:style/:basename.:extension" ,
  :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension"
 validates_attachment_content_type :picture, :content_type=>['image/jpeg', 'image/png', 'image/gif']

# has_attached_file :asset
##  , :path => "/var/lib/hireology/docs/:class/:id/:style/:basename.:extension", :url=> "https://docs.hireology.com/docs/:class/:id/:style/:basename.:extension"
#  validates_attachment_content_type :asset
end
