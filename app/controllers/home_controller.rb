class HomeController < ApplicationController

	def index
		@categories = Category.main_categories
		@projects = Project.all
	end

	def change_laguage
		session[:locale] = params[:locale]
		redirect_to :back
	end

end
