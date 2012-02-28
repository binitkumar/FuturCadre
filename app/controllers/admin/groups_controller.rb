class Admin::GroupsController < ApplicationController
  before_filter :check_role
  before_filter :authenticate_user!
  layout "admin"

  def index
    @groups = Group.all


  end

  def job_groups
    @group      = Group.find_by_id(params[:id])
    @group_jobs = @group.jobs
  end

  def new
    @group = Group.new
    #@jobs  = Job.all
    @photo = Photo.new(params[:photo])
    @rate  = Rating.new
  end

  def create
    @group_new       = Group.new(params[:group])
    @group_new.owner = User.first
    @picture         =""
    #@group_new.group_type_id = params[:group_type_id]
    jobs             = []
    if params[:job_id].present?
      jobs = params[:job_id]
      jobs.each do |job|
        @group_job = Job.find_by_id(job)
        @group_new.jobs << Job.find_by_id(@group_job.id)
      end
    end
    unless params[:photo].blank?
      @picture              = Photo.new(params[:photo])
      @picture.content_type = "group_image"
      @picture.save
    end


    if @group_new.save
      @picture.update_attributes(:imageable_id => @group_new.id, :imageable_type => "Group")
      redirect_to admin_groups_path, :notice => 'Group was successfully created.'
    else
      render :action => "new"
    end
  end

  def show
    @group = Group.find_by_id(params[:id])
  end


  def edit
    @group           = Group.find(params[:id])
    @school_category = @group.school_categories
    @group_jobs      = @group.jobs
    @jobs            =[]
    Job.all.each do |job|
      if  @group_jobs.find_by_id(job)
      else
        @jobs << job
      end
    end
  end

  def update
    @group = Group.find(params[:id])
    jobs   = []
    unless params[:job_id].blank?
      jobs = params[:job_id]
      jobs.each do |job|
        @group_job = Job.find_by_id(job)
        @group.jobs << Job.find_by_id(@group_job.id)
      end
    end
    unless params[:photo].blank?
      @photo = @group.photo
      @photo.update_attributes(params[:photo])
    end


    if @group.update_attributes(params[:group])
      redirect_to admin_groups_path, :notice => 'Group was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_groups_url
  end

  def remove_job
    @remove_job = Job.find_by_id(params[:job_id])
    @group      = Group.find_by_id(params[:group_id])
    @group.jobs.destroy(@remove_job.id)
    @group_jobs = @group.jobs

    @jobs =[]
    Job.all.each do |job|
      if  @group_jobs.find_by_id(job)
      else
        @jobs << job
      end
    end
    render :partial => "group_job_list", :locals => { :jobs => @jobs, :group => @group }
    #render :json => { :html => render_to_string(:partial => '/admin/groups/group_job_list', :locale=>{ :jobs => @jobs, :group => @group }) }.to_json
  end

  def create_group_school

    @group_new       = Group.new(params[:group])
    @group_new.owner = User.first
    @picture         =""
    @school_category = SchoolCategory.find(params[:school_category_id])
    @group_new.school_categories << SchoolCategory.find_by_id(@school_category.id)

    jobs = []
    if params[:job_id].present?
      jobs = params[:job_id]
      jobs.each do |job|
        @group_job = Job.find_by_id(job)
        @group_new.jobs << Job.find_by_id(@group_job.id)
      end
    end


    unless params[:photo].blank?
      @picture              = Photo.new(params[:photo])
      @picture.content_type = "group_image"
      @picture.save
    end
    if @group_new.save
      @picture.update_attributes(:imageable_id => @group_new.id, :imageable_type => "Group")
      redirect_to admin_groups_path, :notice => 'Group was successfully created.'
    else
      render :action => "new"
    end
  end

  def update_school_group
    @school_group = Group.find(params[:gid])
    jobs          = []
    unless  params[:job_id].blank?
      jobs = params[:job_id]
      jobs.each do |job|
        @group_job = Job.find_by_id(job)
        @school_group.jobs << Job.find_by_id(@group_job.id)
      end
    end
    unless params[:photo].blank?
      @school_group.photo.update_attributes(params[:photo])
    end

    if @school_group.update_attributes(params[:group])
      redirect_to admin_groups_path, :notice => 'Group was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def new_manager
    @group       = Group.find_by_id(params[:id])
    @group_users = @group.users
  end

  def set_manager
    @group = Group.find_by_id(params[:group_id])

    if @group.manager_id != params[:id]
      @group.update_attributes(:manager_id => params[:id])
     # redirect_to "admin/groups/'#{@group.id}'", notice: 'Admin was successfully changed.'
      render :nothing => true
    end

  end


end
