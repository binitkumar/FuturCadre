class Job < ActiveRecord::Base
	belongs_to :employer, :polymorphic => true
	belongs_to :country
	belongs_to :region
	belongs_to :city

	def self.search params
    results = all
	end

end
