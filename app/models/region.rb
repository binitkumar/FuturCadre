class Region < ActiveRecord::Base
  belongs_to :country
  has_many :jobs
  has_many :cities
  has_many :projects
end
