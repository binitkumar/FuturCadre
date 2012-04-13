class Admin::PackagesController < ApplicationController
  layout "admin"
  before_filter :check_role
  before_filter :authenticate_user!

  def index
    @packages = Package.all
  end

  def user_package
    @role     = Role.find_by_name("Employer")
    @users    = @role.users
    @packages = Package.all

  end

  def set_package
    @package = Package.find_by_id(params[:id])
    @user    = User.find_by_id(params[:user_id])
    @user.update_attributes!(:package_id => @package.id)
    @user.save
     render :text => @package.name
  end

end
