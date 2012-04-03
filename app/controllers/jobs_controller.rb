class JobsController < ApplicationController
  #before_filter :authenticate_user!,:except=>[:show,:details]
  load_and_authorize_resource :except => [:show, :details, :new_application, :apply_job]

  def show
    @job = Job.find_by_id(params[:id])

  end

  def details
    @job         = Job.find_by_id(params[:id])
    @applied_job = AppliedJob.new
    if user_signed_in?
      if current_user.profile !nil
        @cvs =current_user.profile.assets.where(:content_type => 'cv', :is_publishable => true, :is_deleted => false)
      end
    end
    if params[:sid]=="group"
      render :json => { :html => render_to_string(:partial => '/jobs/details') }.to_json
    else
      render :json => { :html => render_to_string(:partial => '/jobs/details') }.to_json
    end
  end


  def new
    unless current_user.package_id.blank?
     @jobs=Job.find_all_by_employer_id(current_user.id)
     @package=Package.find_by_id(current_user.package_id)
           if(@jobs.count < @package.no_of_jobs)

    if current_user.profile!=nil
      @job            = Job.new
      @skill          = Skill.new(params[:skills])
      @responsibility = Responsibility.new(params[:respon])
      @employer       = current_user
      unless @employer.profile.blank?
        @company_information = @employer.profile.company_information
      else
        @company_information = CompanyInformation.new[:company_information]
      end
    else
      redirect_to profiles_path(), :notice => "Please creater a profile"
    end
           else
             redirect_to :controller=>"employer",:action=>"employer_packages",:notice => "Please update your package "
             end
    else
      redirect_to :controller=>"employer",:action=>"employer_packages",:notice => "Please buy a package"
    end
    end

  def create_job
    @job_new = Job.new(params[:job])
    if params[:job][:date_of_start]=="true"
      date= Time.now
    else
      date= params[:date_of_start_text]
    end
    if params[:job][:annual_salary] == "Negotiable"
      salary = "Negotiable"
    elsif  params[:job][:annual_salary] == "Oui"
      salary = params[:annual_salary_text]
    else
      salary = "Non"
    end

    @job_new.update_attributes(:employer_id => current_user.id, :employer_type => "User", :date_of_start => date, :annual_salary => salary)

    unless params[:company_information].blank?
      @comp = current_user.profile.company_information
      @comp.update_attributes(params[:company_information])
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
    unless params[:education_ids].blank?
      params[:education_ids].each do |education|
        @education = EducationLevel.find_by_id(education)
        @job_new.education_levels << EducationLevel.find_by_id(@education.id)
      end
    end

    unless params[:publication].blank?
      @job_new.update_attributes(:publish => true)
    end
    unless params[:employer_email].blank?
      @job_new.update_attributes(:publisher_email => params[:employer_email])
    end

    if @job_new.save!
      @job_languages = JobLanguage.find_all_by_job_id(@job_new.id)
      @job_languages.each_with_index do |job_lang, j|
        job_lang.update_attributes(:level=> params[:level][j])
      end
      render :json => { :html => render_to_string(:partial => 'job_show', :locale=>{ :job_new => @job_new }) }.to_json
    else
      redirect_to :action => "new"
    end

  end


  def edit
    @job                 = Job.find_by_id(params[:id])
    @company_information = @job.employer.profile.company_information
    @skills              = @job.skills
    @job_languages       = @job.languages
    @job_educations      = @job.education_levels

  end

  def update
    @job_new  = Job.find(params[:id])
    @job_comp = CompanyInformation.find(params[:cid])

    unless params[:job].blank?
      @job_new.update_attributes(params[:job])
    end
    if params[:job][:date_of_start]=="true"
      date= Time.now
    else
      date= params[:date_of_start_text]
    end
    if params[:job][:annual_salary] == "Negotiable"
      salary = "Negotiable"
    elsif  params[:job][:annual_salary] == "Oui"
      salary = params[:annual_salary_text]
    else
      salary = "Non"
    end
    @job_new.update_attributes(:date_of_start => date, :annual_salary => salary)

    unless params[:company_information].blank?
      @job_comp.update_attributes(params[:company_information])
    end

    unless params[:skills][:name].blank?
      skills = params[:skills][:name].split(',')
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
    unless params[:education_ids].blank?
      params[:education_ids].each do |education|
        @education = EducationLevel.find_by_id(education)
        @job_new.education_levels << EducationLevel.find_by_id(@education.id)
      end
    end

    @job_languages = JobLanguage.find_all_by_job_id(@job_new.id)
    @job_languages.each_with_index do |job_lang, j|
      job_lang.update_attributes(:level_id => params[:level][j])
    end
    render :json => { :html => render_to_string(:partial => 'job_show', :locale=>{ :job_new => @job_new }) }.to_json

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

  def new_application
    @job         = Job.find(params[:id])
    @applied_job = AppliedJob.new

    if current_user.profile !nil
      @cvs =current_user.profile.assets.where(:content_type => 'cv', :is_publishable => true, :is_deleted => false)
    end

    render :json => { :html => render_to_string(:partial => 'application_form', :locale=>{ :job_new => @job_new }) }.to_json

  end

  def apply_job

    @job = Job.find(params[:job_id])
    unless params[:cv_id].blank?
      @cv = Asset.find(params[:cv_id])
    end
    @job_application         = AppliedJob.new
    @job_application.user_id = current_user.id
    @job_application.job_id  = @job.id
    unless params[:cv_id].blank?
      @cv                    = Asset.find(params[:cv_id])
      @job_application.cv_id = @cv.id
    end


    if @job_application.save
      #render :json => {:html => render_to_string(:partial => '/job_seeker/job_list', :locale=>{:job_seeker => @job_seeker})}.to_json
      render :json => { :html => render_to_string(:partial => '/job_seeker/job_list', :locale=>{ :job_seeker => @job_seeker }) }.to_json

    else
      redirect_to profiles_path(), :notice => "Please creater a profile"
    end
  end

  def remove_education
    @job       = Job.find_by_id(params[:job_id])
    @education = EducationLevel.find_by_id(params[:ed_id])
    @job.education_levels.destroy(@education.id)
    render :nothing => true
  end


end


