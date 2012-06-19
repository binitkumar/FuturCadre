class Admin::UsersController < ApplicationController
  before_filter :check_role
  before_filter :authenticate_user!
  layout "admin"

  def index
    @users = User.all
  end

  def get_users
    @role  = Role.find_by_name('employer')
    @users = @role.users
    render "admin/users/employer"
  end

  def show
    @user = User.find(params[:id])
    @role = Role.find_all_by_name('employer')

  end

  def set_package
    @user     = User.find(params[:id])
    @packages = Package.all
  end

  def change_package
    @user          = User.find(params[:user_id])
    @package       = Package.find(params[:package_id])
    @package_user  = PackageUser.create(:user_id => @user.id, :package_id => @package.id)
    @job_count     = []
    @search_count  = []
    @package_users = PackageUser.find_all_by_user_id(@user.id)
    @package_users.each do |pack|
      @job_count << pack.package.no_of_jobs
      @search_count << pack.package.no_of_searches

    end
    @total_jobs     = @job_count.inject { |result, element| result + element }
    @total_searches = @search_count.inject { |result, element| result + element }
    @avail_jobs     = @user.avail_jobs + @package.no_of_jobs
    @avail_search   = @user.avail_search + @package.no_of_searches
    @user.update_attributes(:package_id => @package.id, :avail_jobs => @avail_jobs, :avail_search => @avail_search)

    render :text => "ok"
  end

  def destroy

  end

end
