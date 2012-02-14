class Group < ActiveRecord::Base

  acts_as_commentable
  #has_and_belongs_to_many :members,  :class_name => "User"
  has_and_belongs_to_many :jobs
  has_one :photo , :as => :imageable
  has_many :group_users
  has_many :users, :through => :group_users
  belongs_to :owner, :class_name => "User"
  belongs_to :group_type
  has_and_belongs_to_many :school_categories
  has_many :group_questions
  has_many :questions, :through => :group_questions
  has_one :rating, :as => :rateable


end
