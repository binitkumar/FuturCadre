# encoding: utf-8
class Job < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :employer, :polymorphic => true
  belongs_to :country
  belongs_to :region
  belongs_to :city
  belongs_to :category
  belongs_to :contract
  belongs_to :period
  has_and_belongs_to_many :responsibilities
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :groups
  has_many :job_languages
  has_many :languages, :through => :job_languages
  has_many :applied_jobs
  has_and_belongs_to_many :education_levels


  validates_presence_of :name
  validates_presence_of :country, :region, :city


  def self.search params

    conditions = []
    conditions << "jobs.name LIKE '%#{params[:name]}%'"
    conditions << "jobs.category_id LIKE  '%#{params[:category_id]}%'"
    if params[:main]
      conditions << "jobs.country_id LIKE  '%#{params[:main][:country_id]}%'"
      conditions << "jobs.region_id LIKE  '%#{params[:main][:region_id]}%'"
      conditions << "jobs.city_id LIKE  '%#{params[:main][:city_id]}%'"
    elsif params[:search]
      conditions << "jobs.country_id LIKE '%#{params[:search][:country_id]}%'"
      conditions << "jobs.region_id LIKE '%#{params[:search][:region_id]}%'"
      conditions << "jobs.city_id LIKE '%#{params[:search][:city_id]}%'"
    end
    conditions = conditions.join(" AND ")
    find(:all, :conditions => conditions)
  end

  #Education_Levels = ["Ecole d'ingénieur", "Ecole de Commerce", "Ecoles/Universités Etrangères", "IEP", "IUT", "Lycée", "Université", "x - Autre"]

  def location
    "#{city.name}, #{region.name} #{country.name}"
  end

end
