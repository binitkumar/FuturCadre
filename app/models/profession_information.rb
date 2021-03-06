class ProfessionInformation < ActiveRecord::Base
  belongs_to :profile
	belongs_to :category
  belongs_to :sector
  validates_presence_of :profile_id, :start_date, :sector_id,:profession_experience, :job_title

  def self.search params

    conditions = []
    conditions << "profession_informations.profession_experience LIKE '%#{params[:profession_experience]}%'"
    conditions << "profession_informations.career_level = '%#{params[:career_level]}%'"
    conditions << "profession_informations.job_title = '%#{params[:job_title]}%'"
    conditions << "profession_informations.category_id = '%#{params[:category_id]}%'"
    conditions = conditions.join(" OR ")
    find(:all, :conditions => conditions)
  end
end
