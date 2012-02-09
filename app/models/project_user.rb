class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :sender, :class_name => 'User'
  has_many :invitees, :class_name => "User"
end
