class NewsController < ApplicationController

  def index
    @news = News.all(:conditions => { :is_approved => true })

  end

  def show
    @news = News.find(params[:id])
  end

  def new
    @news = News.new
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
    render :json => { :html => render_to_string(:partial => '/news/form', :locale=>{ :news => @news }) }.to_json
  end

  def submit_news
    @news = News.new(params[:news])
    if user_signed_in?
      @news.update_attributes(:user_id => current_user.id)
    else
      @news.update_attributes(:user_id => nil)
    end
    if @news.save
      unless params[:picture].blank?
        @picture              = Photo.new(params[:picture])
        @picture.content_type = "news_image"
        @picture.imageable_id = @news.id
        @picture.imageable_type ="News"
        unless  @picture.save
              render :action => "new"
        end
      end


      render :json => { :html => render_to_string(:partial => '/news/form', :locale=>{ :news => @news }) }.to_json
    end


  end

end
