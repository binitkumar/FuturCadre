class HomeController < ApplicationController

	def index

	end

	def change_laguage
		session[:locale] = params[:locale]
		redirect_back_or_default("/")
	end

end
