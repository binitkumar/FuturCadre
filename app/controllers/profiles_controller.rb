class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_user


  def new
    @profile             = Profile.new
    #    @education_info      = EducationInformation.new
    #    @job_info            = ProfessionInformation.new
    #    @resume              = Asset.new(params[:resume]) #created this for creating a resume object in the same table
    @org_photo           = Asset.new(params[:org_photo])
    @company_information = CompanyInformation.new(params[:company_information])
    session[:return_to]  ||= request.referer
  end

  def upload_photo
   @photo = Asset.new(params[:asset])
    if @photo.save && @photo.errors.empty?
      session[:photo_id] = @photo.id
      render :text => "Photo is successfully uploaded."
    else
      render :json => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @photo })
    end
  end

  def create_job_seeker_basic_information
    if current_user.profile.present?
      @profile = current_user.profile
      success  = @profile.update_attributes(params[:profile])
    else
      @profile      = Profile.new(params[:profile])
      @profile.user = current_user
      success       = @profile.save
    end
    if success
      if session[:photo_id].present?
        @profile.photo.destroy if @profile.photo.present?
        photo = Asset.find_by_id(session[:photo_id])
        photo.update_attributes(:profile_id => @profile.id) if photo.present?
        session[:photo_id] = nil
      end
      @education_informations = @profile.education_informations
      @institutes             = Institute.all
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/education_details') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @profile }) }.to_json
    end
  end

  def remove_edu_info
    @profile  = Profile.find_by_id(params[:profile_id])
    @edu_info = EducationInformation.find_by_id(params[:id])
    @edu_info.destroy
    @education_informations = @profile.education_informations
    render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/education_informations') }.to_json
  end

  def create_job_seeker_education_details
    @institute  = Institute.new
    @institutes = Institute.all
    @profile    = Profile.find_by_id(params[:profile_id])
    @edu_info   = EducationInformation.new(params[:education_info])
    if params[:education_info][:institute_id] =="Select from list"
      params[:education_info][:institute_id] = nil
    elsif  params[:education_info][:institute_id] =="others"
      @edu_info.institute_name = params[:education_info][:institute_name]
    else
      @edu_info.institute_id = params[:education_info][:institute_id]
    end
    @edu_info.profile       = @profile
    success                 = @edu_info.save
    @education_informations = @profile.education_informations
    if success
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/education_details') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @edu_info }) }.to_json
    end
  end

  def create_job_seeker_education_details_next
    @profile = Profile.find_by_id(params[:profile_id])
    unless params[:skip].blank?
      @edu_info = EducationInformation.new(params[:education_info])
      if params[:education_info][:institute_id] =="Select from list"
        params[:education_info][:institute_id] = nil
      elsif  params[:education_info][:institute_id] =="others"
        @edu_info.institute_name = params[:education_info][:institute_name]
      else
        @edu_info.institute_id = params[:education_info][:institute_id]
      end
      @edu_info.profile = @profile
      success           = @edu_info.save
    else
      success = true
    end
    if success
      @professional_informations = @profile.profession_informations
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/professional_experience') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @edu_info }) }.to_json
    end
  end

  def remove_prof_info
    @profile   = Profile.find_by_id(params[:profile_id])
    @prof_info = ProfessionInformation.find_by_id(params[:id])
    @prof_info.destroy
    @professional_informations = @profile.profession_informations
    render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/professional_informations') }.to_json
  end

  def create_job_seeker_professional_experience
    @profile                   = Profile.find_by_id(params[:profile_id])
    @prof_info                 = ProfessionInformation.new(params[:prof_info])
    @prof_info.profile         = @profile
    success                    = @prof_info.save
    @professional_informations = @profile.profession_informations
    if success
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/professional_experience') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @prof_info }) }.to_json
    end
  end

  def create_job_seeker_professional_experience_next
    @profile = Profile.find_by_id(params[:profile_id])
    unless params[:skip].blank?
      @prof_info         = ProfessionInformation.new(params[:prof_info])
      @prof_info.profile = @profile
      success            = @prof_info.save
    else
      success = true
    end

    if params[:prof_info][:end_date]==""
      date= Time.now
    else
      date= params[:prof_info][:end_date]
    end
    @prof_info.update_attributes(:end_date => date)

    if success
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/additional_information') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @prof_info }) }.to_json
    end
  end


  def show
    @profile = Profile.find(params[:id])

    @countryy=[]
    @regionn =[]
    @cityy   =[]
    unless @profile.locations.blank?
      @ar = @profile.locations.split(",")

      i=0
      j=0
      while i<@ar.length
        @countryy[i]=Country.find_by_id(@ar[j].to_i)
        j           =j+1
        @regionn[i] =Region.find_by_id(@ar[j].to_i)
        j           =j+1
        @cityy[i]   =City.find_by_id(@ar[j].to_i)
        j           =j+1
        i           =i+1
      end
    end
    @image =""
    @profile.assets.each do |asset|
      if asset.content_type == "profile_image"
        @image << asset.photo.url
      end
    end
  end

  def edit
    @profile                 = Profile.find(params[:id])
    @company_information     = @profile.company_information
    @asset                   = @profile.assets.where("content_type =?", "profile_image")
    @profession_informations = @profile.profession_informations
    @resume                  = @profile.assets.where("content_type =?", "cv")
    @org_photo               = @profile.assets.where("content_type =?", "logo")
    @education_informations  = @profile.education_informations
    @city                    = @profile.city
    @regions                 = @city.country.regions
    @region                  = @profile.region
    @cities                  = @region.cities
    @country                 = @city.country
  end

  def update_employer
    @profile             = Profile.find_by_id(params[:id])
    @company_information = CompanyInformation.find_by_id(params[:comp_id])
    #@asset = @profile.assets.where("content_type =?", "profile_image").first
    if @profile.update_attributes(params[:profile])
      @company_information.update_attributes(params[:company_information])
      unless params[:asset].blank?
        @profile.assets.each do |img|
          if img.content_type == "profile_image"
            img.update_attributes(params[:asset])
          end
        end
      end
      unless params[:org_photo].blank?
        @profile.assets.each do |logo|
          if logo.content_type == "company_logo"
            logo.update_attributes(params[:org_photo])
          end
        end
      end
      redirect_to @profile, :notice => 'Profile was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def update_job_seeker
    @profile        = Profile.find_by_id(params[:id])
    @job_info       = ProfessionInformation.find_by_id(params[:job_id])
    @education_info = EducationInformation.find_by_id(params[:edu_id])

    if @profile.update_attributes(params[:profile])
      @education_info.update_attributes(params[:education_info])
      @job_info.update_attributes(params[:job_info])

      unless @profile.assets.each do |img|
        if img.content_type == "profile_image"
          img.update_attributes(params[:asset])
        end
      end
      end
      unless params[:resume].blank?
        @profile.assets.each do |cv|
          if cv.content_type == "cv"
            cv.update_attributes(params[:resume])
          end
        end
      end
      redirect_to @profile, :notice => 'Profile was successfully updated.'
    else
      render :action => "edit"
    end
  end


  def create_institute
    @institute = Institute.new(params[:institute])
    if @institute.save
      @institutes = Institute.all
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/institute_list'), :locals => { :institutes => @institutes } }.to_json
    end
  end

  def create_job_seeker_additional_information

    @profile = Profile.find_by_id(params[:profile_id])
    if params[:date_of_start]=="true"
      date= Time.now
    else
      date= params[:date_of_start_text]
    end
    if params[:add_info][:country_id]=="Select from list"

    else

      unless params[:add_info][:country_id].blank?
        location=params[:add_info][:country_id] +','+params[:add_info][:region_id]+','+params[:add_info][:city_id]
      end
      if params[:add_info][:country_id_1] !="Select from list"
        unless params[:add_info][:country_id_1].blank?
          location1= params[:add_info][:country_id_1] +','+params[:add_info][:regions_add_1]+','+params[:add_info][:cities_add_1]
          location =location+','+location1
        else
          location=location
        end
      end
      if params[:add_info][:country_id_2] !="Select from list"
        unless params[:add_info][:country_id_2].blank?
          location2= params[:add_info][:country_id_2] +','+params[:add_info][:regions_add_2]+','+params[:add_info][:cities_add_2]
          location =location+','+location2
        else
          location=location
        end
      end
      if params[:add_info][:country_id_3] !="Select from list"
        unless params[:add_info][:country_id_3].blank?
          location3= params[:add_info][:country_id_3] +','+params[:add_info][:regions_add_3]+','+params[:add_info][:cities_add_3]
          location =location+','+location3
        else
          location=location
        end
      end
      if params[:add_info][:country_id_4] !="Select from list"
        unless params[:add_info][:country_id_4].blank?
          location4= params[:add_info][:country_id_4] +','+params[:add_info][:regions_add_4]+','+params[:add_info][:cities_add_4]
          location =location+','+location4
        else
          location=location
        end
      end
    end
    @ar   = params[:sector_ids]
    sector=@ar[0]
    j     =1
    while j<@ar.length
      sector=sector+','+@ar[j]
      j     =j+1
    end

    unless params[:language_ids].blank? and params[:level].blank?
      @language=params[:language_ids]
      @level   =params[:level]
      lang     = @language[0]+','+@level[0]
      i        =1
      while i<@language.length
        lang= lang+','+@language[i]+','+@level[i]
        i   =i+1
      end
    end

    @profile.update_attributes(:job_title => params[:job_title], :languages => lang, :Sector_ids => sector, :locations => location, :date_of_start => date, :work_authorization => params[:work_authorization], :desired_job_type => params[:desired_job_type], :desired_job_status => params[:desired_job_status], :salary_to => params[:salary_to], :salary_from => params[:salary_from], :currency => params[:currency], :salary_period => params[:salary_period], :willing => params[:willing], :willing_to_travel => params[:willing_to_travel])
    redirect_to @profile, :notice => 'Profile was successfully updated.'
  end


  def create_employer_basic_information
    if current_user.profile.present?
      @profile = current_user.profile
      success  = @profile.update_attributes(params[:profile])
    else
      @profile      = Profile.new(params[:profile])
      @profile.user = current_user
      success       = @profile.save
    end
    if success
      if session[:photo_id].present?
        @profile.photo.destroy if @profile.photo.present?
        photo = Asset.find_by_id(session[:photo_id])
        photo.update_attributes(:profile_id => @profile.id) if photo.present?
        session[:photo_id] = nil
      end
      @company_information = CompanyInformation.new(params[:company_information])
      @sectors = Sector.all
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/employer/company_details') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @profile }) }.to_json
    end
  end

  def create_employer_company_details
    @sectors = Sector.all
    @profile = Profile.find_by_id(params[:profile_id])
    if @profile.company_information.present?
      @company_info = @profile.company_information
      success       = @company_info.update_attributes(params[:company_information])
    else
      @company_info         = CompanyInformation.new(params[:company_information])
      @company_info.profile = @profile
      success               = @company_info.save
    end
    if success
      redirect_to @profile, :notice => 'Profile was successfully created.'
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @company_info }) }.to_json
    end
  end
end

