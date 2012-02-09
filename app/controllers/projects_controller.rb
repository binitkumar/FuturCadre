class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    #@projects = Project.all
    @category   = Category.first
    @projects   = @category.projects
    @categories = Category.all

  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project     = Project.new
    @project_doc = Photo.new(params[:project_doc])

  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create_project
    @project = Project.new(params[:project])
    @project.update_attributes(:owner => current_user)
    unless params[:project_doc].blank?
      @project_pub              = Photo.new(params[:project_doc])
      @project_pub.content_type = "project_publication"
      @project_pub.imageable    = @project
      @project_pub.save
    end
    if @project.save
      render :json => { :html => render_to_string(:partial => 'show_project', :locale=>{ :project => @project }) }.to_json
    else
      redirect_to(:action => "new", :notice => "Project was not created")
    end
  end


  # PUT /projects/1
  # PUT /projects/1.json
  def update_project
    @project = Project.find(params[:id])
    unless params[:project_doc].blank?
      @project_pub              = Photo.new(params[:project_doc])
      @project_pub.content_type = "project_publication"
      @project_pub.imageable    = @project
      @project.save
    end

    if @project.update_attributes(params[:project])
      redirect_to :action => "index"
    else
      render :json => { :html => render_to_string(:partial => 'show_project', :locale=>{ :project => @project }) }.to_json
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :ok }
    end
  end

  def my_projects
    @owner    = User.find(params[:id])
    @projects = Project.find_all_by_owner_id(@owner.id)
    if current_user.job_seeker?
      render :json => { :html => render_to_string(:partial => '/job_seeker/my_projects', :locale=>{ :employer => @owner, :projects => @projects }) }.to_json
    else
      render :json => { :html => render_to_string(:partial => '/employer/my_projects', :locale=>{ :job_seeker => @owner, :projects => @projects }) }.to_json
    end
  end

  def project_category
    @category = Category.find_by_id(params[:id])
    @projects = @category.projects
    render :json => { :html => render_to_string(:partial => '/projects/project_categories', :locale=>{ :theses => @theses }) }.to_json
  end

  def project_details

    @project    = Project.find(params[:id])
    @categories = Category.all
    @comments   = @project.comments.all
  end

  def project_wall
    @project  = Project.find(params[:id])
    @comment  = @project.comments.build
    @comments = @project.comments.all
    render :json => { :html => render_to_string(:partial => '/projects/project_wall', :locale=>{ :project => @project }) }.to_json
  end

  def add_comment
    @project = Project.find(params[:thesis_id])
    @project.comments.create(params[:comment])
    @comments = @project.comments.all
    render :json => { :html => render_to_string(:partial => '/projects/project_wall', :locale=>{ :project => @project }) }.to_json
  end

  def project_body
    @project= Project.find(params[:id])
    render :json => { :html => render_to_string(:partial => '/projects/project_path', :locale=>{ :thesis => @thesis }) }.to_json
  end
end
