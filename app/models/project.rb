class Project < ActiveRecord::Base
  belongs_to :country
  belongs_to :region
  belongs_to :city
  belongs_to :category
  has_one :photo, :as => :imageable
  has_many :project_users
  has_many :users, :through => :project_users
  belongs_to :owner, :class_name => "User"

  validates_presence_of :city, :country, :region


end
