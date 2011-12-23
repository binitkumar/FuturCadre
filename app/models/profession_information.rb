class ProfessionInformation < ActiveRecord::Base
	belongs_to :profile
  validates_presence_of :profile
end
