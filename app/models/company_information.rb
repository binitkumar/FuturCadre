class CompanyInformation < ActiveRecord::Base
	belongs_to :profile
	belongs_to :country
	belongs_to :region
	belongs_to :city
end
