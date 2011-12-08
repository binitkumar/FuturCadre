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
   end

  def create_profile

    @profile_new = Profile.create(:user_id =>current_user.id, :country_id => params[:country_id], :region_id=>params[:region_id],
                                  :city_id => params[:city_id], :first_name => params[:profile][:first_name], :last_name =>params[:profile][:last_name],
                                  :address => params[:profile][:address], :phone => params[:profile][:phone])

    #@photo = Asset.create(:user_id => current_user.id, :profile_id =>@profile_new.id,:photo_file_name =>params[:profile][:asset][:photo]


    #@asset = Asset.create(:profile_id =>@profile_new.id, :user_id=>current_user.id,
    #                      :photo_file_name =>@photo.original_filename)

    #educational information
    unless @profile_new.blank?
      @education_information = EducationInformation.create(:profile_id =>@profile_new.id, :degree_level => params[:profile][:education_info][:degree_level],
                                                           :institute  => params[:profile][:education_info][:institute], :major_subject => params[:profile][:education_info][:major_subject],
                                                           :year       => params[:profile][:education_info][:year])
    end
    #professional information
    unless @profile_new && @education_information.blank?
      @job_information = ProfessionInformation.create(:profile_id            => @profile_new.id, :profession_industry => params[:profile][:job_info][:profession_industry],
                                                      :category_id           => params[:category_id], :job_title => params[:profile][:job_info][:job_title],
                                                      :profession_experience => params[:profile][:job_info][:profession_experience], :career_level => params[:profile][:job_info][:career_level],
                                                      :company_name          => params[:profile][:job_info][:company_name])
    end
    render :text => "ok"
  end


end
