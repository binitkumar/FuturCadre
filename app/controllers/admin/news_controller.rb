class Admin::NewsController < ApplicationController
  layout "admin"
  before_filter :check_role
  before_filter :authenticate_user!

  def index
    @news = News.all(:conditions => { :is_approved => false })
  end

  def show
    @new = News.find(params[:id])
  end

  def approve_news
    @news = News.find_by_id(params[:id])
    @news.update_attributes(:is_approved => true)
    render :nothing => true


  end
end
