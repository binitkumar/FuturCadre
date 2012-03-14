class Sector < ActiveRecord::Base
  has_many :company_informations
  has_many :profession_informations
end
