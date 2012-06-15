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
  #has_and_belongs_to_many :skills
  has_and_belongs_to_many :groups
  has_many :job_languages
  has_many :languages, :through => :job_languages
  #has_many :applied_jobs

  has_many :applied_jobs
  has_many :users, :through => :applied_jobs

  has_and_belongs_to_many :education_levels


  validates_presence_of :name, :category_id, :description, :annual_salary
  validates_presence_of :country, :region, :city


  def self.search params

    conditions = []
    #transaction_success_show << "SELECT jobs.name FROM jobs where"

    if params[:company_id] == "Select from list"

      conditions << "SELECT jobs.name , jobs.id FROM jobs where jobs.name LIKE '%#{params[:name]}%'"
    else

      conditions << "SELECT jobs.name , jobs.id FROM jobs"
      abc = []
      abc << "LEFT OUTER JOIN company_informations co ON jobs.employer_id = co.profile_id
              where jobs.name LIKE"
      conditions << abc

    end

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

    #conditions = conditions.join(" AND ")
    if params[:company_id] == "Select from list"
      conditions = conditions.join(" AND ")
      @job       = find_by_sql(conditions)
    else
      @job = find_by_sql(conditions)
    end
    @jobs = []
    @job.each do |j|
      @jobs << Job.find_by_id(j.id)
    end
    return @jobs

  end

  #Education_Levels = ["Ecole d'ingénieur", "Ecole de Commerce", "Ecoles/Universités Etrangères", "IEP", "IUT", "Lycée", "Université", "x - Autre"]

  def find_company(com_id)
    company = CompanyInformation.find(com_id)
    jobs    = company.profile.user.created_jobs

  end

  def location
    "#{city.name}, #{region.name} #{country.name}"
  end

end
