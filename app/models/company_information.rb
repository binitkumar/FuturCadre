class CompanyInformation < ActiveRecord::Base
	belongs_to :profile
	belongs_to :country
	belongs_to :region
	belongs_to :city
  belongs_to :sector

  validates_presence_of :profile_id, :name, :sector_id, :address
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
end
