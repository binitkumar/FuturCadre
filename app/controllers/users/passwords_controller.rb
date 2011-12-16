class Users::PasswordsController < Devise::PasswordsController

   # GET /resource/password/new
  def new
    build_resource({})
    render_with_scope :new
  end

  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    render_with_scope :edit
  end
end