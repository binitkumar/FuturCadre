class ProfilesController < ApplicationController

	before_filter :authenticate_user!

	def show
		@profile = Profile.find(params[:id])
	end

	def new
    @profile = Profile.new
	end

	def create

	end

end
