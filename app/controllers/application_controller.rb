class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  #include SessionsHelper
  protect_from_forgery
  before_filter :set_locale

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || signed_in_root_path(resource_or_scope)
  end

  def signed_in_root_path(resource_or_scope)
    current_user.webmaster? ? dashboard_admin_home_index_path : "/#{current_user.role}/dashboard"
    scope = Devise::Mapping.find_scope!(resource_or_scope)

    home_path  = "#{scope}_root_path"
    if current_user.webmaster?
      respond_to?(home_path, true) ? "/admin" : "/admin"
    else
      respond_to?(home_path, true) ? "/#{current_user.role}/dashboard" : "/#{current_user.role}/dashboard"
    end
  end

  def stored_location_for(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    session.delete("#{scope}_return_to")
  end

  def after_sign_out_path_for(resource_or_scope)
    $role.present? && $role == "webmaster" ? login_admin_home_index_path : root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def set_locale
    @locale = I18n.locale = session[:locale] || I18n.default_locale
  end

  def check_role
    unless current_user.webmaster?
      redirect_to "/"
    end
  end

  def authorize_user
    unless user_signed_in?
      redirect_to :root, :alert => "You are not authorized to view this page"
    end
  end

  def check_employer
    unless current_user.employer?
      redirect_to :root, :alert => "You are not authorized to view this page"
    end
  end

  def check_job_seeker
    unless current_user.job_seeker?
      redirect_to :root, :alert => "You are not authorized to view this page"
    end
  end


end
