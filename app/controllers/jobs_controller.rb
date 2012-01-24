class JobsController < ApplicationController

  def show
    @job = Job.find_by_id(params[:id])
  end

  def details
    @job = Job.find_by_id(params[:id])
    if params[:sid]=="group"
      render :json => { :html => render_to_string(:partial => '/jobs/details') }.to_json
    else
      render :json => { :html => render_to_string(:partial => '/jobs/details') }.to_json
    end
  end


  def new
    @job            = Job.new
    @skill          = Skill.new(params[:skills])
    @responsibility = Responsibility.new(params[:respon])
    @employer       = current_user
    unless @employer.profile.blank?
      @company_information = @employer.profile.company_informations.first
    else
      @company_information = CompanyInformation.new[:company_information]
    end
  end

  def create_job
    params[:job].inspect
    @job_new = Job.new(params[:job])
    @job_new.update_attributes(:employer_id => current_user.id, :employer_type => "User")

    unless params[:company_information].blank?
      @comp            = CompanyInformation.new(params[:company_information])
      @comp.profile_id = current_user.id
      @comp.update_attributes(:country_id => params[:job][:country_id],
                              :region_id  => params[:job][:region_id], :city_id => params[:job][:city_id])
      @comp.save!
    else
      puts "None company info added"
    end
    unless params[:skill][:name].blank?
      skills = params[:skill][:name].split(',')
      skills.each do |skill|
        @skill_new = Skill.create(:name => skill)
        @job_new.skills << Skill.find_by_id(@skill_new.id)
      end
    else
      puts "None skill added"
    end
    unless params[:language_ids].blank?
      params[:language_ids].each_with_index do |language, i|
        @language = Language.find_by_id(language)
        @job_new.languages << Language.find_by_id(@language.id)
      end
    end

    if @job_new.save!
      @job_languages = JobLanguage.find_all_by_job_id(@job_new.id)
      @job_languages.each_with_index do |job_lang, j|
        job_lang.update_attributes(:level_id => params[:level][j])
      end
      render :json => { :html => render_to_string(:partial => 'job_show', :locale=>{ :job_new => @job_new }) }.to_json
    else
      redirect_to :action => "new"
    end

  end

  def apply_job

  end


  def edit
    @job_edit            = Job.find_by_id(params[:id])
    @company_information = @job_edit.employer.profile.company_informations.first
    @skills              = @job_edit.skills
    @job_languages       = @job_edit.languages

  end

  def update
    @job_update = Job.find(params[:id])
    @job_comp   = CompanyInformation.find(params[:cid])

    unless params[:job].blank?
      @job_update.update_attributes(params[:job])
    end
    unless params[:company_information].blank?
      @job_comp.update_attributes(params[:company_information])
    end

    unless params[:skills][:name].blank?
      skills = params[:skills][:name].split(',')
      skills.each do |skill|
        @skill_new = Skill.create(:name => skill)
        @job_update.skills << Skill.find_by_id(@skill_new.id)
      end
    else
      puts "None skill added"
    end

    unless params[:language_ids].blank?
      params[:language_ids].each_with_index do |language, i|
        @language = Language.find_by_id(language)
        @job_update.languages << Language.find_by_id(@language.id)
      end
    end

    @job_languages = JobLanguage.find_all_by_job_id(@job_update.id)
    @job_languages.each_with_index do |job_lang, j|
      job_lang.update_attributes(:level_id => params[:level][j])
    end


  end

  def remove_language
    @job      = Job.find_by_id(params[:job_id])
    @language = Language.find_by_id(params[:lang_id])
    @job.languages.destroy(@language.id)
    render :nothing => true
  end

  def job_employer
    @employer = User.find_by_id(params[:id])
    @jobs_emp = Job.find_all_by_employer_id(@employer.id)

  end

end


