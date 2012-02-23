class Users::RegistrationsController < Devise::RegistrationsController

  def new
    @role = Role.find_by_name("job_seeker")
     resource = build_resource({})

  end


  def create
    build_resource
    @role = Role.find_by_id(params[:role_id])
    resource.roles << @role

    if   simple_captcha_valid? && params[:terms] && resource.save
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
      if !simple_captcha_valid?
        set_flash_message :error, :missing_captcha
      elsif params[:terms]==nil
        set_flash_message :error, :missing_privacy
      end
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end

  def new_user
    @role = Role.find_by_name(params[:role_name].to_s)
    resource = build_resource({})
    render :json => { :html => render_to_string(:partial => 'form', :locals => { :role => @role }) }.to_json
  end
end