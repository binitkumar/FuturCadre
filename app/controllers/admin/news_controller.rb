class Admin::NewsController < ApplicationController
  layout "admin"
  before_filter :check_role
  before_filter :authenticate_user!

  def index
    @news = News.all
  end

  def show
    @new = News.find(params[:id])
  end

  def approve_news
    @news = News.find_by_id(params[:id])
    if params[:status]=="true"
      @news.update_attributes(:is_approved => true)
    else
      @news.update_attributes(:is_approved => false)
    end
    render :text => "ok"
  end

  def new
    @news    = News.new
    @picture = Photo.new
    news_attr
  end


  def create
    @news         = News.new(params[:news])
    @news.user_id = current_user.id
    if @news.save
      @rating          = Rating.new
      @rating.rateable = @news
      @rating.rate     = 0
      @rating.save
      unless params[:picture].blank?
        @picture                = Photo.new(params[:picture])
        @picture.content_type   = "news_image"
        @picture.imageable_id   = @news.id
        @picture.imageable_type ="News"
        if !@picture.save
          news_attr
          #render :partial => '/news/form', :locale => { :news => @news }
          render :action => "new"
        end
      end
      redirect_to admin_news_index_path(), :notice => "News was successfully created"
    else
      news_attr
      render :action => "new"
    end

  end

  def edit
    @news = News.find(params[:id])
    news_attr
  end

  def update
    @news = News.find(params[:id])
    if params[:picture] != ""

      @news_pub = Photo.find_by_imageable_id(@news.id)
      unless @news_pub.blank?
        @news.photo.destroy
        @news_publication              = Photo.new(params[:photo])
        @news_publication.content_type = "news_image"
        @news_publication.imageable    = @news
        @news_publication.save!
      else
        @news_publication              = Photo.new(params[:photo])
        @news_publication.content_type = "news_image"
        @news_publication.imageable    = @news
        if !@news_publication.save
          news_attr
          render :action => "edit"
          return
        end
      end
    end
    if @news.update_attributes(params[:news])
      redirect_to admin_news_index_path(), :notice => "News was successfully created"
    else
      render :action => "edit"
    end
  end

end


def destroy
  @news = News.find(params[:id])
  @news.destroy
  redirect_to admin_news_index_path(), :notice => "News was successfully deleted  "
end

private
def news_attr
  @news_categories = NewsCategory.all
end



