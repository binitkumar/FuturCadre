class Asset < ActiveRecord::Base
  belongs_to :profile
  #belongs_to :group
  #belongs_to :event
  has_many :applied_jobs

  has_attached_file :photo, :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension",
                    :url          => "/system/:attachment/:id/:style/:basename.:extension"
  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'application/msword', 'application/pdf', 'docx']


  validates_attachment_size :photo, :less_than => 1.megabytes, :message => "must be less than 2 Mb."

end
