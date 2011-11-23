class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :set_locale

	private

	def set_locale
		I18n.locale = session[:locale] || I18n.default_locale
	end

	def redirect_back_or_default(default)
		redirect_to(session[:return_to] || default)
		session[:return_to] = nil
	end

end
