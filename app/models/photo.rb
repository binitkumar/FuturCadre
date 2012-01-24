class Photo < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true

  has_attached_file :image, :styles => { :small => "100x100>" }, :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension",
                    :url            => "/system/:attachment/:id/:style/:basename.:extension"
  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif']
end