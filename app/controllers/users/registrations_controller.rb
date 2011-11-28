class Users::RegistrationsController < Devise::RegistrationsController

	def new
		@role = Role.find_by_name(params[:role].to_s)
		super
	end

end