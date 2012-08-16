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
      @jobs   =Job.find_all_by_employer_id(current_user.id)
      @package = Package.find_by_id(current_user.package_id)
      #if (@jobs.count < @package.no_of_jobs)
      if  current_user.created_jobs.count <= current_user.avail_jobs
        if current_user.profile!=nil
          @job                = Job.new
          @skill              = Skill.new(params[:skills])
          @responsibility     = Responsibility.new(params[:respon])
          @employer           = current_user
          session[:return_to] ||= request.referer
          unless @employer.profile.blank?
            @company_information = @employer.profile.company_information
          else
            @company_information = CompanyInformation.new[:company_information]
          end
        else
          redirect_to profiles_path(), :notice => "Please creater a profile"
        end
      else
        redirect_to :controller => "employer", :action => "employer_packages", :notice => "Please update your package "
      end
    else
      redirect_to :controller => "employer", :action => "employer_packages", :notice => "Please buy a package"
    end
  end

  def create_job
    @job = Job.new(params[:job])
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
    #@job_new.update_attributes(:employer_id => current_user.id, :employer_type => "User", :date_of_start => date, :annual_salary => salary)
    @job.employer      = current_user
    @job.date_of_start = date
    @job.annual_salary = salary
    @job.package_id    = current_user.package_id
    @job.sector_id     = current_user.profile.company_information.sector_id


    unless params[:company_information].blank?
      @comp = current_user.profile.company_information
      @comp.update_attributes(params[:company_information])
    end

    unless params[:language_ids].blank?
      params[:language_ids].each_with_index do |language, i|
        @language = Language.find_by_id(language)
        @job.languages << Language.find_by_id(@language.id)
      end
    end
    unless params[:education_ids].blank?
      params[:education_ids].each do |education|
        @education = EducationLevel.find_by_id(education)
        @job.education_levels << EducationLevel.find_by_id(@education.id)
      end
    end

    unless params[:publication].blank?
      @job.publish = true
    end
    unless params[:employer_email].blank?
      @job.publisher_email = params[:employer_email]
    end

    if @job.save
      @job_languages = JobLanguage.find_all_by_job_id(@job.id)
      @job_languages.each_with_index do |job_lang, j|
        job_lang.update_attributes(:level => params[:level][j])
      end

      render :partial => 'job_show', :locale => { :job => @job }
    else

      render :partial => '/shared/error_messages', :locals => { :object => @job }
    end

  end


  def edit
    @job                 = Job.find_by_id(params[:id])
    @company_information = @job.employer.profile.company_information
    @skills              = @job.skills
    @job_languages       = @job.languages
    @job_educations      = @job.education_levels
    @city                = @job.city
    @regions             = @city.country.regions
    @region              = @job.region
    @cities              = @region.cities
    @country             = @city.country
  end

  def update
    @job      = Job.find(params[:id])
    @job_comp = CompanyInformation.find(params[:cid])

    unless params[:job].blank?
      if @job.update_attributes(params[:job])

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
        @job.update_attributes(:date_of_start => date, :annual_salary => salary)

        unless params[:company_information].blank?
          @job_comp.update_attributes(params[:company_information])
        end
        # To edit language and levels
        #updating sector id
        @job.update_attributes(:sector_id => current_user.profile.company_information.sector_id)
        unless params[:language_ids].blank?
          params[:language_ids].each_with_index do |language, i|

            @language = Language.find_by_id(language)
            if @job.languages.include?(@language)
              @job_language = JobLanguage.find_by_job_id_and_language_id(@job.id, @language.id)
              @job_language.update_attributes(:level_id => params[:level][i])
            else
              @job.languages << Language.find_by_id(@language.id)
            end

          end
        end
        # To edit Education Level
        unless params[:education_ids].blank?
          @cds = @job.education_levels
          if @cds != nil
            @cds.destroy_all
          end
          params[:education_ids].each do |education|
            @education = EducationLevel.find_by_id(education)
            if @job.education_levels.include?(@education)
            else
              @job.education_levels << EducationLevel.find_by_id(@education.id)
            end
          end
        end

        @job_languages = JobLanguage.find_all_by_job_id(@job.id)
        @job_languages.each_with_index do |job_lang, j|
          job_lang.update_attributes(:level_id => params[:level][j])
        end
        render :partial => 'job_show', :locale => { :job_new => @job_new }
      else
        render :partial => '/shared/error_messages', :locals => { :object => @job }
      end
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

  def new_application
    @job = Job.find(params[:id])
    #@applied_job = AppliedJob.new
    if current_user.profile !nil
      @cvs =current_user.profile.assets.where(:content_type => 'cv', :is_publishable => true, :is_deleted => false)
    end
    render :partial => 'application_form', :locale => { :job => @job }
  end

  def apply_job
    @job = Job.find(params[:job_id])
    unless params[:cv_id].blank?
      @cv = Asset.find(params[:cv_id])
    end
    unless params[:asset].blank?
      @cover_letter =Asset.new(params[:asset])
      if @cover_letter.save && @cover_letter.errors.empty?
        render :text => "Photo is successfully uploaded."
      else
        render :partial => '/shared/error_messages', :locals => { :object => @cover_letter }
      end
    end
    @job_application                 = AppliedJob.new
    @job_application.user_id         = current_user.id
    @job_application.job_id          = @job.id
    @job_application.cv_id           = @cv.id
    @job_application.employer_id     = @job.employer_id
    @job_application.cover_letter_id = @cover_letter.id
    if @job_application.save
      render :text => "ok"
    else
      render :partial => '/shared/error_messages', :locals => { :object => @job_application }

    end
  end

  def remove_education
    @job       = Job.find_by_id(params[:job_id])
    @education = EducationLevel.find_by_id(params[:ed_id])
    @job.education_levels.destroy(@education.id)
    render :nothing => true
  end


end


