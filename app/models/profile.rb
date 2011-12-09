class Profile < ActiveRecord::Base

	belongs_to :user
	belongs_to :country
	belongs_to :region
	belongs_to :city
	has_many :education_informations
	has_many :profession_informations
	has_many :company_informations
	has_many :assets


  def full_name
    n = first_name

    if n && n.length > 0
      n += " "
    end

    n += last_name

    return n
  end

end
