class ProfilesController < ApplicationController

	before_filter :authenticate_user!

	def show
		@profile = Profile.find(params[:id])
	end

  def new
    @profile        = Profile.new
    @education_info = EducationInformation.new
    @job_info = ProfessionInformation.new
    @asset = Asset.new(params[:asset])
    @resume = Asset.new(params[:resume]) #created this for creating a resume object in the same table
    @org_photo = Asset.new(params[:org_photo])
    @company_information = CompanyInformation.new(params[:company_information])

   end

  def create_job_seeker
    @profile_new = Profile.create(:user_id =>current_user.id, :country_id => params[:country_id], :region_id=>params[:region_id],
                                  :city_id => params[:city_id], :first_name => params[:profile][:first_name], :last_name =>params[:profile][:last_name],
                                  :address => params[:profile][:address], :phone => params[:profile][:phone])

    @photo = params[:profile][:asset]
    unless @photo.blank?
      @asset            = Asset.new(params[:profile][:asset])
      @asset.user_id    = current_user.id
      @asset.profile_id = @profile_new.id
      @asset.save
    end

    #educational information
    unless @profile_new.blank?
      @education_info            = EducationInformation.new(params[:profile][:education_info])
      @education_info.profile_id = @profile_new.id
      @education_info.save
    end
    #professional information
    unless @profile_new.blank?
      @job_information            = ProfessionInformation.new(params[:profile][:job_info])
      @job_information.profile_id =@profile_new.id
      @job_information.save

      @resume                     = params[:profile][:asset]
      unless @resume.blank?
        @cv            = Asset.new(params[:profile][:resume])
        @cv.user_id    = current_user.id
        @cv.profile_id = @profile_new.id
        @cv.save
      end

    end
   # unless @profile_new.save?
   #           @profile_new.errors.each { |e| puts "PR Error: ", e }
   #end

  render :text => "ok"
      #redirect_to(@profile_new ,:notice => 'Profile was successfully created.')
  end

  def create_employer
    @profile_new = Profile.create(:user_id =>current_user.id, :country_id => params[:country_id], :region_id=>params[:region_id],
                                  :city_id => params[:city_id], :first_name => params[:profile][:first_name], :last_name =>params[:profile][:last_name],
                                  :address => params[:profile][:address], :phone => params[:profile][:phone])

    @photo = params[:profile][:asset]
    unless @photo.blank?
      @asset            = Asset.new(params[:profile][:asset])
      @asset.user_id    = current_user.id
      @asset.profile_id = @profile_new.id
      @asset.save
    end

    unless @profile_new.blank?
      @company_information            = CompanyInformation.new(params[:profile][:company_information])
      @company_information.profile_id = @profile_new.id
      @company_information.save

      @photo = params[:profile][:asset]
      unless @photo.blank?
        @image            = Asset.new(params[:profile][:org_photo])
        @image.user_id    = current_user.id
        @image.profile_id = @profile_new.id
        @image.save
      end

    end

  render :text => "ok"
    #redirect_to(@profile_new ,:notice => 'Profile was successfully created.')
  end

  #def show
  #    @profile = Profile.find(params[:id])
  #
  #
  #
  #
  #end
end
