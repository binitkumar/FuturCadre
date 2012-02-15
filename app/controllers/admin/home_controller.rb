class Admin::HomeController < ApplicationController

  layout "admin"

  def login

  end

  def dashboard
    unless current_user.webmaster?
      redirect_to "/"
    end

  end

end
