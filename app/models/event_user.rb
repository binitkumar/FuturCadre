class EventUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  belongs_to :sender, :class_name => 'User'
  has_many  :invite,  :class_name => "User"
end
