class ProfilesController < ApplicationController

	before_filter :authenticate_user!

	def show
		@profile = Profile.find(params[:id])
	end

	def new
    @profile = Profile.new
    @education_info = @profile.education_informtions
    @job_info = @profile.profession_informtions

 	end

  def create_profile

    @profile_new = Profile.create(:user_id =>current_user.id, :country_id => params[:country_id], :region_id=>params[:region_id],
                   :city_id => params[:city_id], :first_name => params[:profile][:first_name], :last_name =>params[:profile][:last_name],
                   :address => params[:profile][:address], :phone => params[:profile][:phone])

   #educational information
   unless @profile_new.blank?
       @education_info = EducationInformation.create(:profile_id => @profile_new.id)
   end
    render :text => "ok"
  end

end
