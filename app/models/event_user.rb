class EventUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_mailer

  belongs_to :sender, :class_name => 'User'
  has_many  :invitees,  :class_name => "User"
end
