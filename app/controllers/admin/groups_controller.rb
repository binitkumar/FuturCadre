class Admin::GroupsController < ApplicationController
  layout "admin"

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
    @jobs = Job.all
  end

  def create_job_group
    @group_new = Group.new(params[:group])
    @group_job = Job.find(params[:job_id])
    @group_new.jobs << Job.find_by_id(@group_job.id)
      if @group_new.save
        redirect_to admin_groups_path, :notice => 'Group was successfully created.'
    else
      render :action => "new"
    end
  end

  def edit
    @group      = Group.find(params[:id])
    @group_jobs = @group.jobs
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
