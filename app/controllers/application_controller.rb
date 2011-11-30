class ApplicationController < ActionController::Base
  protect_from_forgery

	def after_sign_in_path_for(resource_or_scope)
    current_user.webmaster? ? dashboard_admin_home_index_path : "/#{current_user.role}/dashboard"
  end

	def after_sign_out_path_for(resource_or_scope)
    $role.present? && $role == "webmaster" ? login_admin_home_index_path : root_path
  end

end
