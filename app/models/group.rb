class Group < ActiveRecord::Base

  #require "acts_as_commentable"
   #has_and_belongs_to_many :members,  :class_name => "User"
  has_and_belongs_to_many :jobs
  has_one :asset
  has_many :group_users
  has_many :users, :through => :group_users
  belongs_to :owner, :class_name => "User"
  #acts_as_commentable

end
