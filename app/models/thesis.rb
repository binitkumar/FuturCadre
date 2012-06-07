class Thesis < ActiveRecord::Base
  acts_as_commentable
  belongs_to :category
  has_one :photo, :as => :imageable
  #belongs_to :owner, :class_name => "User"
  belongs_to :owner, :polymorphic => true
  has_many :theses_users
  has_many :users, :through => :theses_users
  validates_presence_of :name, :description, :date_of_publish, :category_id, :no_of_pages
  validates_uniqueness_of :name
  validates_numericality_of :no_of_pages


end


