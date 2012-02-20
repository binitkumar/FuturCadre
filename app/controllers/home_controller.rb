class HomeController < ApplicationController

	def index
		@categories = Category.main_categories
    @companies = CompanyInformation.all
		@projects = Project.all
    @groups = Group.where("featured =? ",  true)
	end

	def change_laguage
		session[:locale] = params[:locale]
		redirect_to :back
	end

end
