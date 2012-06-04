class NewsController < ApplicationController

  def index

    @news = News.all(:conditions => { :is_approved => true })
    news_attr
  end

  def show
    @news = News.find(params[:id])
  end

  def new
    @news = News.new
    news_attr
  end


  def edit
    @news = News.find(params[:id])
  end


  #def update
  #  @news = News.find(params[:id])
  #  if @news.update_attributes(params[:news])
  #    format.html { redirect_to @news, notice: 'News was successfully updated.' }
  #  else
  #    format.html { render action: "edit" }
  #  end
  #end

  def destroy
    @news = News.find(params[:id])
    @news.destroy


  end

  def suggest_news
    @news    = News.new
    @picture = Photo.new
    news_attr
    render :json => { :html => render_to_string(:partial => '/news/form', :locale => { :news => @news }) }.to_json
  end

  def submit_news
    news_attr
    @news = News.new(params[:news])
    if user_signed_in?
      @news.update_attributes(:user_id => current_user.id)
    else
      @news.update_attributes(:user_id => nil)
    end
    if @news.save
      unless params[:picture].blank?
        @picture                = Photo.new(params[:picture])
        @picture.content_type   = "news_image"
        @picture.imageable_id   = @news.id
        @picture.imageable_type ="News"
        unless  @picture.save
          news_attr
          render :action => "new"
        end
      end
      render :json => { :html => render_to_string(:partial => '/news/form', :locale => { :news => @news }) }.to_json
    end
  end

  def news_comment
    @news                = News.find(params[:news_id])
    @new_comment         = @news.comments.new(params[:comment])
    @new_comment.user_id = current_user.id
    @new_comment.save!
    @news_comments = @news.comments.all
    render :json => { :html => render_to_string(:partial => '/news/news_wall', :locale => { :news => @news }) }.to_json
  end

  def fetch_news
    if params[:type] == "all"
      @news = News.all(:conditions => { :is_approved => true })
      render :json => { :html => render_to_string(:partial => '/news/news_index', :locale => { :news => @news }) }.to_json
    else
      unless params[:news_id].blank?
        #@category = NewsCategory.find_by_id(params[:news_id])
        #@news     = @category.news(:is_approved => true )
        @news = News.find_all_by_news_category_id(params[:news_id])
      end
      render :json => { :html => render_to_string(:partial => '/news/news_index', :locale => { :news => @news }) }.to_json
    end

  end

  private
  def news_attr
    @news_categories = NewsCategory.all
  end
end
