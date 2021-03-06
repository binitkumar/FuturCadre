class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @projects = Project.find(:all, :conditions => { :is_deleted => false })
  end


  def show
    @project       = Project.find(params[:id])
    @project_users = ProjectUser.find_all_by_project_id(@project.id, :conditions => { :is_approved => true })

  end


  def new
    @project = Project.new(params[:project])
    @photo   = Photo.new
  end


  def edit
    @project = Project.find(params[:id])
  end


  def create
    @project       = Project.new(params[:project])
    @project.owner = current_user
    if @project.save
      unless params[:photo].blank?
        @picture              = Photo.new(params[:photo])
        @picture.content_type = "project_image"
        @picture.imageable    = @project
        unless @picture.save
          render :action => "new"
        end
      end
      redirect_to @project, :notice => 'Project was successfully created.'
    else

      render :action => "new"
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to @project, :notice => 'Project was successfully updated.'
    else
      render :action => "edit"
    end
  end


  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_url
  end

  def invite_users

    @project = Project.find_by_id(params[:id])
    @users   = User.find_by_sql(" SELECT * FROM users u WHERE
         u.id NOT IN ( SELECT pu.user_id FROM projects p
        	INNER JOIN project_users pu ON
        	pu.project_id = p.id where p.id ='#{params[:id]}')
        	AND u.id != '#{current_user.id}' AND u.id != 1")

    render :json => { :html => render_to_string(:partial => '/projects/invitation_form', :locale => { :project => @project }) }.to_json
  end

  def project_invitation
    if params[:add].to_i== 1
      @project_user            = ProjectUser.new
      @project_user.user_id    = params[:user_id]
      @project_user.project_id = params[:id]
      @project_user.save
      @project = Project.find_by_id(params[:id])
      approve  = invitation_response_projects_url(:id => @project_user.project.id, :user_id => @project_user.user.id, :cond => true)
      reject   = invitation_response_projects_url(:id => @project_user.project.id, :user_id => @project_user.user.id, :cond => false)

      current_user.send_message("Invited to Project", "Welcome to my project click to join Project'  #{@project.name}' <br/> '#{@project.tag_line}' <br/> '#{@project.description}'  '<a href='#{approve}'> approve</a> or '<a href='#{reject}'> reject</a>", @project_user.user)
      render :nothing => true

    else
      @project_user1 = ProjectUser.find_by_user_id_and_project_id(params[:user_id], params[:id])
      @project_user1.destroy
      render :nothing => true
    end

  end

  def invitation_response
    @project =Project.find_by_id(params[:id])

    if params[:cond]== "true"
      @project_user1 = ProjectUser.find_by_user_id_and_project_id(params[:user_id], params[:id])
      @project_user1.update_attributes(:is_approved => true)
      current_user.send_message("Request to join Project", "You request to join project' #{@project.name}' is accepted. Welcome to  <br/> '#{@project.tag_line}' <br/> '#{@project.description}'", @project_user1.user)
      redirect_to @project, :notice => 'Project was successfully joined.'
    else
      @projects = Project.all
      redirect_to projects_path()
    end

  end

  def my_projects
    @projects = Project.find_all_by_owner_id(current_user.id, :conditions => { :is_deleted => false })
    if current_user.job_seeker?
      render :json => { :html => render_to_string(:partial => '/projects/my_projects', :locale => { :employer => current_user }) }.to_json
    else
      render :json => { :html => render_to_string(:partial => '/projects/my_projects', :locale => { :job_seeker => current_user }) }.to_json
    end
  end

  def delete_project
    @project = Project.find(params[:id])
    @project.update_attributes(:is_deleted => true)
    @projects = Project.find_all_by_owner_id(current_user.id, :conditions => { :is_deleted => false })
    if current_user.job_seeker?
      render :json => { :html => render_to_string(:partial => '/projects/my_projects', :locale => { :employer => current_user }) }.to_json
    else
      render :json => { :html => render_to_string(:partial => '/projects/my_projects', :locale => { :job_seeker => current_user }) }.to_json
    end
  end

  def project_request
    @project_user            = ProjectUser.new
    @project_user.user_id    = current_user.id
    @project_user.project_id = params[:id]
    @project_user.save
    @project       = Project.find_by_id(params[:id])
    @project_owner = @project.owner
    approve        = invitation_response_projects_url(:id => @project_user.project.id, :user_id => @project_user.user.id, :cond => true)
    reject         = invitation_response_projects_url(:id => @project_user.project.id, :user_id => @project_user.user.id, :cond => false)
    current_user.send_message("Request to join Project'#{@project.name}'", "'#{current_user.name}' has request to join project click to '<a href='#{approve}'> approve</a> or '<a href='#{reject}'> reject</a>", @project_owner)
    render :nothing => true
  end

  def project_wall
    @project  = Project.find_by_id(params[:id])
    @comment  = @project.comments.build
    @comments = @project.comments.all
    render :json => { :html => render_to_string(:partial => '/projects/project_wall', :locale => { :project => @project }) }.to_json

  end

  def project_description
    @project  = Project.find_by_id(params[:id])
    @comments = @project.comments
    render :json => { :html => render_to_string(:partial => '/projects/project_description', :locale => { :project => @project, :comments => @comments }) }.to_json
  end

  def add_comment
    @project    = Project.find(params[:project_id])
    @new_comment= @project.comments.create(params[:comment])
    @new_comment.update_attributes(:user_id => current_user.id)
    @comments = @project.comments.all
    render :json => { :html => render_to_string(:partial => '/projects/project_wall', :locale => { :project => @project }) }.to_json
  end


end
