class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :except =>[:index,:show]
  def index
    @projects = Project.all


  end


  def show
    @project = Project.find(params[:id])
  end


  def new
    @project = Project.new(params[:project])
    @photo   = Photo.new
  end


  def edit
    @project = Project.find(params[:id])
  end


  def create
    @project = Project.new(params[:project])
    @project.owner_id = current_user.id
   if @project.save
      unless params[:photo].blank?
        @picture              = Photo.new(params[:photo])
        @picture.content_type = "project_image"
        @picture.imageable    = @project
        unless @picture.save
          render :action => "new"
        end
      end
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render action: "edit"
    end
  end


  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_url
  end

  def invite_users

    @project = Project.find_by_id(params[:id])
    @users = User.find_by_sql( " SELECT * FROM users u WHERE
         u.id NOT IN ( SELECT pu.user_id FROM projects p
        	INNER JOIN project_users pu ON
        	pu.project_id = p.id where p.id ='#{params[:id]}')
        	AND u.id != '#{current_user.id}' AND u.id != 1")

    render :json => { :html => render_to_string(:partial => '/projects/invitation_form', :locale=>{ :project => @project }) }.to_json
  end
  def project_invitation
    @project = Project.find_by_id(params[:id])
    @user = User.find_by_id(params[:user_id])
     @project_user = ProjectUser.new
     @project_user.user_id = @user.id
    @project_user.project_id = @project.id
    @project_user.save
    render :nothing => true

  end
end
