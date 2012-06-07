class EducationInformation < ActiveRecord::Base
  belongs_to :profile
  belongs_to :institute
  validates_presence_of :profile_id, :start_date, :end_date, :degree_level, :major_subject

  def self.search params

    conditions = []
    conditions << "education_informations.degree_level LIKE '%#{params[:degree_level]}%'"
    conditions << "education_informations.institute = '%#{params[:institute]}%'"
    conditions << "education_informations.major_subject = '%#{params[:major_subject]}%'"
    conditions << "education_informations.year = '%#{params[:year]}%'"
    conditions = conditions.join(" OR ")
    find(:all, :conditions => conditions)
  end

end
