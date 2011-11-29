class HomeController < ApplicationController

	def index
		@categories = Category.all
		@projects = Project.all
	  if user_signed_in?
			redirect_to :controller => current_user.role, :action => "dashboard"
		end
	end

	def change_laguage
		session[:locale] = params[:locale]
		redirect_to :back
	end

end
