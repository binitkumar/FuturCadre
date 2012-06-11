class Skill < ActiveRecord::Base
  has_and_belongs_to_many :jobs
  #validates_associated :jobs
  has_many :project_skills
  has_many :projects, :through => :project_skills


end
