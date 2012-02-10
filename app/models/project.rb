class Project < ActiveRecord::Base
  acts_as_commentable
  belongs_to :category
  has_one :photo, :as => :imageable
  belongs_to :owner, :class_name => "User"
  has_many :project_users
  has_many :users, :through => :project_users
  has_many :project_invitations
  has_many :project_skills
  has_many :skills, :through => :project_skills


end
