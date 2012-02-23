class Profile < ActiveRecord::Base

  belongs_to :user
  belongs_to :country
  belongs_to :region
  belongs_to :city
  has_many :education_informations
  has_many :profession_informations
	
  #has_many :company_informations
  has_many :assets
  has_many :employer_profiles
  has_one :company_information


  validates_presence_of :first_name, :last_name, :zip_code, :address
  validates_presence_of :country_id, :city_id, :region_id
  #validates_format_of :phone,:message => "must be a valid telephone number.", :with => /^[\(\)0-9\- \+\.]{10,20}$/
  validates_format_of :phone,:message => "must be a valid telephone number e.g. 000-0000000.", :with => /^[a-zA-Z0-9]{3}-?[a-zA-Z0-9]{7}$/

  def full_name
    n = first_name
    if n && n.length > 0
      n += " "
    end
    n += last_name
    return n
  end

  def full_address

    ad = address
    if ad && ad.length > 0
      ad +=""
    end
    ad += "," + self.city.name + "," + self.region.name + ","+ self.country.name
    return ad
  end

  def self.job_seeker_search(params)
    @role      = Role.find_by_name("job_seeker")
    conditions = []
  end

  def self.search_job_seeker params

    conditions = []
    conditions << "profiles.first_name LIKE '%#{params[:first_name]}%'"
    conditions << "profiles.last_name = '%#{params[:last_name]}%'"
    conditions << "profiles.country_id = '%#{params[:country_id]}%'"
    conditions << "profiles.region_id = '%#{params[:region_id]}%'"
    conditions << "profiles.city_id = '%#{params[:city_id]}%'"
    conditions = conditions.join(" OR ")
    find(:all, :conditions => conditions)


  end
end