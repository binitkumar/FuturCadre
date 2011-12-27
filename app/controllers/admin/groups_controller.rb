class Admin::GroupsController < ApplicationController
  before_filter :check_role
  before_filter :authenticate_user!
  layout "admin"

  def index
    @groups = Group.all
  end
  def job_groups
     @group = Group.find_by_id(params[:id])
     @group_jobs = @group.jobs
  end
  def new
    @group = Group.new
    #@jobs  = Job.all
  end
  def create
    @group_new = Group.new(params[:group])
    #@group_job = Job.find(params[:job_id])
    #@group_new.jobs << Job.find_by_id(@group_job.id)
    if @group_new.save
      redirect_to admin_groups_path, :notice => 'Group was successfully created.'
    else
      render :action => "new"
    end
  end
  def new_job_group
    @group     = Group.find(params[:id])
    @job_group = @group.jobs.new()
    @jobs      = Job.all
  end

  def create_job_group
    @job_group_new = Group.find(params[:id])
    @job           = Job.find(params[:job_id])
    @job_group_new.jobs << Job.find_by_id(@job.id)

    if @job_group_new.save
      redirect_to job_groups_admin_groups_path(:id => @job_group_new.id), :notice => 'Job Group was successfully created.'
    else
      render :action => "new_job_group"
    end
  end
  def edit
    @group      = Group.find(params[:id])
    @group_jobs = @group.jobs
  end
  def edit_job_group
    #@group = Group.find(params[:id])
    #@job_group = Job.find(params[:j_id])
  end

  def update
    @group = Group.find(params[:id])
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
end
