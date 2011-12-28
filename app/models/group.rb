class Group < ActiveRecord::Base
   #has_and_belongs_to_many :members,  :class_name => "User"
   has_and_belongs_to_many :jobs
   has_one :asset
   has_many :group_users
   has_many :users, :through => :group_users
   #has_many :users, :as=> :members, :through => :group_users
end
