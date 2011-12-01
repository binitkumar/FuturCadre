class Profile < ActiveRecord::Base

	belongs_to :user
	belongs_to :country
	belongs_to :region
	belongs_to :city
	has_many :education_informtions
	has_many :profession_informtions
	has_many :company_informtions
	has_many :assets
	
end
