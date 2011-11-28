class Users::RegistrationsController < Devise::RegistrationsController

	def new
		@role = Role.find_by_name(params[:role].to_s)
		super
	end

	def create
		@role = Role.find_by_id(params[:user][:role_id])
		super
	end

end