class Admin::GroupsController < ApplicationController
  layout "admin"


  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create_group
    @group_new = Group.new(params[:group])
    @group_new.update_attributes(:school_id => params[:school_id], :category_id =>params[:category_id])
    if @group_new.save
      redirect_to admin_groups_path, :notice => 'Group was successfully created.'
    else
      render :action => "new"
    end
  end

  def edit
    @group = Group.find(params[:id])
    @category = @group.category
    @school = @group.school
  end

  def update
    @group = Group.find(params[:id])

     #  unless params[:school_id].blank?
    #        @group.update_attributes(:school_id => params[:school_id])
    #  end
    # unless params[:category_id].blank?
    #  @group.update_attributes(:category_id => params[:category_id])
    #end

    if @group.update_attributes(params[:group])

      redirect_to admin_groups_path, :notice => 'Group was successfully updated.'
    else
      render :action => "edit"
    end
  end
end
