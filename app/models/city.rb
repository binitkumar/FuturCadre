class City < ActiveRecord::Base
belongs_to :country
belongs_to :region
has_many :jobs
has_many:projects
end
