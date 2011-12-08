class Profile < ActiveRecord::Base

	belongs_to :user
	belongs_to :country
	belongs_to :region
	belongs_to :city
	has_many :education_informations
	has_many :profession_informations
	has_many :company_informations
	has_many :assets
	
end
