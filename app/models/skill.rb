class Skill < ActiveRecord::Base
   has_and_belongs_to_many :jobs
  validates_associated :jobs
end
