class NewsController < ApplicationController
  # GET /news
  # GET /news.json
  def index
    @news = News.all(:conditions => { :is_approved => true })

  end

  # GET /news/1
  # GET /news/1.json
  def show
    @news = News.find(params[:id])
  end

  # GET /news/new
  # GET /news/new.json
  def new
    @news = News.new
  end

  # GET /news/1/edit
  def edit
    @news = News.find(params[:id])
  end

  # POST /news
  # POST /news.json
  def create
    @news = News.new(params[:news])
    if @news.save
      format.html { redirect_to @news, notice: 'News was successfully created.' }
    else
      format.html { render action: "new" }
    end

  end

  # PUT /news/1
  # PUT /news/1.json
  def update
    @news = News.find(params[:id])
    if @news.update_attributes(params[:news])
      format.html { redirect_to @news, notice: 'News was successfully updated.' }
    else
      format.html { render action: "edit" }
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    @news = News.find(params[:id])
    @news.destroy
    format.html { redirect_to news_index_url }

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
        @picture.imageable_id = @news
        if  @picture.save

        end
      end
     render :json => { :html => render_to_string(:partial => '/news/form', :locale=>{ :news => @news }) }.to_json
    end
  end

end
