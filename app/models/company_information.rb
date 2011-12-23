class CompanyInformation < ActiveRecord::Base
	belongs_to :profile
	belongs_to :country
	belongs_to :region
	belongs_to :city

  validates_presence_of :profile
end
