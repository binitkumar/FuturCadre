class Admin::PackageUsersController < ApplicationController
  layout "admin"
  before_filter :check_role
  before_filter :authenticate_user!

  def index
    @invoices = PackageUser.all
  end

  def show
  end


end
