class Users::RegistrationsController < Devise::RegistrationsController

	def new
		@role = Role.find_by_name(params[:role].to_s)
		super
	end

	def create
    build_resource
    @role = Role.find_by_id(params[:user][:role_id])
		resource.roles << @role
    if params[:terms] && verify_recaptcha && resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => redirect_location(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
			set_flash_message :alert, "We are sorry! Something went wrong. Please try again later."
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end

end