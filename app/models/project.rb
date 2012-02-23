class Project < ActiveRecord::Base
  belongs_to :country
  belongs_to :region
  belongs_to :city
  belongs_to :category

end
