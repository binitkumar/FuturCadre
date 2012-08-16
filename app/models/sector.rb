class Sector < ActiveRecord::Base
  has_many :company_informations
  has_many :profession_informations
  has_many :jobs
end
