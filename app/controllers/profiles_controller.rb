class ProfilesController < ApplicationController

  before_filter :authorize_user

  #def show
  #	@profile = Profile.find(params[:id])
  #end

  def new
    @profile             = Profile.new
    @education_info      = EducationInformation.new
    @job_info            = ProfessionInformation.new
    @asset               = Asset.new(params[:asset])
    @resume              = Asset.new(params[:resume]) #created this for creating a resume object in the same table
    @org_photo           = Asset.new(params[:org_photo])
    @company_information = CompanyInformation.new(params[:company_information])

  end

  def create_job_seeker
    @profile = Profile.new(params[:profile])
    @profile.update_attributes(:user_id => current_user.id, :country_id => params[:profile][:country_id], :city_id => params[:profile][:city_id], :region_id => params[:profile][:region_id])

    @photo = params[:asset]
    unless @photo.blank?
      @asset              = Asset.new(params[:asset])
      @asset.content_type = "profile_image"
      @asset.user_id      = current_user.id
      @asset.profile_id   = @profile.id
      @asset.save
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
        @cv.save
      end

    end
    if @profile_job.save
      redirect_to(@profile, :notice => 'Profile was successfully created.')
    else
      render :action => "new"
    end
  end

  def create_employer
    @profile = Profile.new(params[:profile])
    @profile.update_attributes(:user_id => current_user.id, :country_id => params[:profile][:country_id], :city_id => params[:profile][:city_id], :region_id => params[:profile][:region_id])

    @photo = params[:asset]
    unless @photo.blank?
      @asset              = Asset.new(params[:asset])
      @asset.content_type = "profile_image"
      @asset.user_id      = current_user.id
      @asset.profile_id   = @profile.id
      @asset.save
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
        @image.save
      end

    end
    if @profile.save
      @company_information.update_attributes(:profile_id => @profile.id)
      redirect_to(@profile, :notice => 'Profile was successfully created.')
    else
      render :action =>"new"

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
    @profile             = Profile.find(params[:id])
    @company_information = @profile.company_informations.first
    @asset               = @profile.assets.where("content_type =?", "profile_image")
    @job_info            =@profile.profession_informations.first
    @resume              = @profile.assets.where("content_type =?", "cv")
    @org_photo           = @profile.assets.where("content_type =?", "logo")
    @education_info      = @profile.education_informations.first

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


end

