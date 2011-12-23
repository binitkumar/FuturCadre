class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  protect_from_forgery
  before_filter :set_locale


  def after_sign_in_path_for(resource_or_scope)
    current_user.webmaster? ? dashboard_admin_home_index_path : "/#{current_user.role}/dashboard"
  end

  def after_sign_out_path_for(resource_or_scope)
    $role.present? && $role == "webmaster" ? login_admin_home_index_path : root_path
  end

  private

  def set_locale
    @locale = I18n.locale = session[:locale] || I18n.default_locale
  end

 def check_role
    unless current_user.webmaster?
         redirect_to "/"
    else
        redirect_to dashboard_admin_home_index_path
    end
  end

end
