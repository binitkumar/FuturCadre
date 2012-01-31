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

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #def store_location
  #  session[:return_to] = request.request_uri
  #end
  #
  #def redirect_back_or_default(default)
  #  redirect_to(session[:return_to] || default)
  #  session[:return_to] = nil
  #end

#def redirect_to_back(default = root_url)
#    if !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
#      redirect_to :back
#    else
#      redirect_to default
#    end
#  end


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
        redirect_to :root,  :alert => "You are not authorized to view this page"
    end
  end
  def check_employer
    unless current_user.employer?
        redirect_to :root,  :alert => "You are not authorized to view this page"
    end
  end

  def check_job_seeker
    unless current_user.job_seeker?
         redirect_to :root,  :alert => "You are not authorized to view this page"
    end
  end


end
