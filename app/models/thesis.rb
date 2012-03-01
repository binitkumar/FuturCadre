class Thesis < ActiveRecord::Base
  acts_as_commentable
  belongs_to :category
  has_one :photo, :as => :imageable
  #belongs_to :owner, :class_name => "User"
  belongs_to :owner, :polymorphic => true
  has_many :theses_users
  has_many :users, :through => :theses_users
end


