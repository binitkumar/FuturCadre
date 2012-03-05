class ProfilesController < ApplicationController

  before_filter :authorize_user

  #def show
  #	@profile = Profile.find(params[:id])
  #end

  def new
    @profile             = Profile.new
    #    @education_info      = EducationInformation.new
    #    @job_info            = ProfessionInformation.new
    #    @resume              = Asset.new(params[:resume]) #created this for creating a resume object in the same table
    @org_photo           = Asset.new(params[:org_photo])
    @company_information = CompanyInformation.new(params[:company_information])


  end

  def upload_photo
    @photo = Asset.new(params[:asset])
    if @photo.save && @photo.errors.empty?
      session[:photo_id] = @photo.id
      render :text => "Photo is successfuly uploaded."
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
    unless params[:skip].present?
      @edu_info         = EducationInformation.new(params[:education_info])
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
    unless params[:skip].present?
      @prof_info         = ProfessionInformation.new(params[:prof_info])
      @prof_info.profile = @profile
      success            = @prof_info.save
    else
      success = true
    end
    if success
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/additional_information') }.to_json
    else
      render :json => { :seccess => false, :html => render_to_string(:partial => '/shared/error_messages', :locals => { :object => @prof_info }) }.to_json
    end
  end


  def create_job_seeker
    @profile = Profile.new(params[:profile])
    @profile.update_attributes(:user_id => current_user.id, :country_id => params[:profile][:country_id], :city_id => params[:profile][:city_id], :region_id => params[:profile][:region_id])

    @photo = params[:asset]
    unless @photo.blank?
      @asset              = Asset.new(params[:asset])
      @asset.content_type =
          @asset.user_id = current_user.id
      @asset.profile_id   = @profile.id

      unless @asset.save
        render :action => "new"
        return
      end
    end

    #educational information
    unless @profile.blank?
      @education_info            = EducationInformation.new(params[:education_info])
      @education_info.profile_id = @profile.id
      @education_info.save
    end
    #professional information
    unless @profile.blank?
      @job_information            = ProfessionInformation.new(params[:job_info])
      @job_information.profile_id =@profile.id
      @job_information.save

      @resume = params[:resume]
      unless @resume.blank?
        @cv              = Asset.new(params[:resume])
        @cv.content_type = "cv"
        @cv.user_id      = current_user.id
        @cv.profile_id   = @profile.id
        unless @cv.save
          render :action => "new"
          return
        end
      end

    end
    if @profile.save
      redirect_to(@profile, :notice => 'Profile was successfully created.')
    else
      render :action => "new"
    end
  end

  def create_employer
    @profile = Profile.new(params[:profile])
    @profile.update_attributes(:user_id => current_user.id, :country_id => params[:profile][:country_id], :city_id => params[:profile][:city_id], :region_id => params[:profile][:region_id])

    if @profile.save
      @photo = params[:asset]
      unless @photo.blank?
        @asset              = Asset.new(params[:asset])
        @asset.content_type = "profile_image"
        @asset.user_id      = current_user.id
        @asset.profile_id   = @profile.id
        unless @asset.save
          render :action => "new"
          return
        end
      end

      unless @profile.blank?
        @company_information            = CompanyInformation.new(params[:company_information])
        @company_information.country_id = params[:company_information][:country_id]
        @company_information.region_id  = params[:company_information][:region_id]
        @company_information.city_id    = params[:company_information][:city_id]
        @company_information.save

        @photo = params[:org_photo]
        unless @photo.blank?
          @image              = Asset.new(params[:org_photo])
          @image.content_type = "company_logo"
          @image.user_id      = current_user.id
          @image.profile_id   = @profile.id
          unless @image.save
            render :action => "new"
            return
          end
        end

      end

      @company_information.update_attributes(:profile_id => @profile.id)
      redirect_to(@profile, :notice => 'Profile was successfully created.')
    else
      render :action => "new"

    end
  end

  def show
    @profile = Profile.find(params[:id])
    @image   =""
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
      render :json => { :seccess => true, :html => render_to_string(:partial => '/profiles/job_seeker/institute_list'), :locals =>{:institutes => @institutes} }.to_json
    end
  end


  def create_job_seeker_additional_information
    @profile    = Profile.find_by_id(params[:profile_id])
    redirect_to @profile, :notice => 'Profile was successfully updated.'
  end

end

