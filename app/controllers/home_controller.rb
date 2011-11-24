class HomeController < ApplicationController

	def index
		@categories = Category.all
	end

	def change_laguage
		session[:locale] = params[:locale]
		redirect_to :back
	end

end
