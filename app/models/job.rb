class Job < ActiveRecord::Base
	has_and_belongs_to_many :users
	belongs_to :employer, :polymorphic => true
	belongs_to :country
	belongs_to :region
	belongs_to :city
  belongs_to :category
  has_and_belongs_to_many :responsibilities
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :groups
  has_many :job_languages
  has_many :languages, :through => :job_languages
  belongs_to  :contract
  belongs_to  :period

  validates_presence_of :name
  validates_presence_of :country, :region, :city


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

	def location
		"#{city.name}, #{region.name} #{country.name}"
	end

end
