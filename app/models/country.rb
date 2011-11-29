class Country < ActiveRecord::Base
has_many :jobs
has_many :regions
has_many :cities
end
