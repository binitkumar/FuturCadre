class Job < ActiveRecord::Base
	belongs_to :employer, :polymorphic => true
	belongs_to :country
	belongs_to :region
	belongs_to :city

	def self.search params
		conditions = []
    conditions << "jobs.name LIKE '%#{params[:name]}%'"
    conditions << "jobs.category_id = '%#{params[:category_id]}%'"
    conditions << "jobs.country_id = '%#{params[:country_id]}%'"
    conditions << "jobs.region_id = '%#{params[:region_id]}%'"
    conditions << "jobs.city_id = '%#{params[:city_id]}%'"
    conditions = conditions.join(" AND ")
    find(:all, :conditions => conditions)
	end

end
