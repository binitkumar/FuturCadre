class ThesesController < ApplicationController

  def index
    unless params[:id]!=nil
      @category = Category.first
      @theses   = Thesis.all
    else
      @category = Category.find_by_id(params[:id])
      @theses   = @category.theses
    end
    @categories = Category.all

  end

  def my_theses
    @user      = User.find_by_id(params[:id])
    @my_theses = User.theses
    render :json => { :html => render_to_string(:partial => 'my_theses') }.to_json
  end


  def show
    @thesis = Thesis.find(params[:id])

  end


  def new
    @thesis     = Thesis.new
    @thesis_doc = Photo.new(params[:thesis_doc])

  end


  def edit
    @thesis = Thesis.find(params[:id])
  end


  def create_thesis
    @thesis = Thesis.new(params[:thesis])
    @thesis.update_attributes(:owner => current_user)
    unless params[:thesis_doc].blank?
      @thesis_pub              = Photo.new(params[:thesis_doc])
      @thesis_pub.content_type = "thesis_publication"
      @thesis_pub.imageable    = @thesis
      @thesis_pub.save
    end
    if @thesis.save
      render :json => { :html => render_to_string(:partial => 'show_theses', :locale=>{ :thesis => @thesis }) }.to_json
    else
      redirect_to(:action => "new", :notice => "Thesis was not created")
    end
  end


  def update
    @thesis = Thesis.find(params[:id])
    unless params[:thesis_doc].blank?
      @thesis_pub              = Photo.new(params[:thesis_doc])
      @thesis_pub.content_type = "thesis_publication"
      @thesis_pub.imageable    = @thesis
      @thesis_pub.save
    end

    if @thesis.update_attributes(params[:thesis])

      redirect_to :action => "index"
    else
      render :json => { :html => render_to_string(:partial => 'show_theses', :locale=>{ :thesis => @thesis  }) }.to_json

    end

  end


  def download_thesis
    @thesis     = Thesis.find_by_id(params[:id])
    @thesis_doc = @thesis.photo.image
    send_file @thesis_doc.path
  end

  def thesis_details

    @thesis     = Thesis.find(params[:id])
    @categories = Category.all
    @comments   = @thesis.comments.all
  end

  def thesis_wall
    @thesis   = Thesis.find(params[:id])
    @comment  = @thesis.comments.build
    @comments = @thesis.comments.all
    render :json => { :html => render_to_string(:partial => '/theses/thesis_wall', :locale=>{ :thesis => @thesis }) }.to_json
  end

  def add_comment
    @thesis = Thesis.find(params[:thesis_id])
    @thesis.comments.create(params[:comment])
    @comments = @thesis.comments.all
    render :json => { :html => render_to_string(:partial => '/theses/thesis_wall', :locale=>{ :thesis => @thesis }) }.to_json
  end

  def thesis_body
    @thesis = Thesis.find(params[:id])
    render :json => { :html => render_to_string(:partial => '/theses/thesis_path', :locale=>{ :thesis => @thesis }) }.to_json
  end

  def thesis_category
    @category = Category.find_by_id(params[:id])
    @theses   = @category.theses
    render :json => { :html => render_to_string(:partial => '/theses/thesis_categories', :locale=>{ :theses => @theses }) }.to_json
  end


  def search_thesis
    @thesis_result= Thesis.find_all_by_name(params[:search_term])
    render :json => { :html => render_to_string(:partial => '/theses/search_result') }.to_json
  end

end
