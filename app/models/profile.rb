class Profile < ActiveRecord::Base

  belongs_to :user
  belongs_to :country
  belongs_to :region
  belongs_to :city
  has_many :education_informations
  has_many :profession_informations
  has_many :company_informations
  has_many :assets


  validates_presence_of :first_name, :last_name, :zip_code, :address
  validates_presence_of :country_id, :city_id, :region_id


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

    sql = "SELECT first_name FROM PROFILES p
    INNER JOIN education_informations ei
    ON p.id = ei.profile_id
    INNER JOIN profession_informations
    ON p.id = profession_informations.profile_id
    WHERE p.first_name = '' OR p.last_name = 'RANA' OR p.country_id = 24
    OR p.region_id = 561 OR p.city_id = 1000 OR ei.degree_level = "masters"
    OR ei.major_subject = "computer science" OR ei.institute = "#{}}"
    OR ei.year = '2011'
    OR profession_informations.category_id = 1
    OR profession_informations.job_title = 'sr'
    OR profession_informations.profession_experience = '10'
    OR profession_informations.profession_industry = 'it'"

  end


end
