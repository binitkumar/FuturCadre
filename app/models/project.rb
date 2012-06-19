class Project < ActiveRecord::Base
  acts_as_commentable
  belongs_to :country
  belongs_to :region
  belongs_to :city
  belongs_to :category
  has_one :photo, :as => :imageable
  has_many :project_users
  has_many :users, :through => :project_users
  #belongs_to :owner, :class_name => "User"
  belongs_to :owner, :polymorphic => true
  validates_presence_of :city, :country, :region, :name, :category_id, :skill, :description, :research, :tag_line
  validates_uniqueness_of :name


end
