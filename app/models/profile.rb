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


end
