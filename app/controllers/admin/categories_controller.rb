class Admin::CategoriesController < ApplicationController
  before_filter :check_role
  before_filter :authenticate_user!
	layout "admin"
  def index
    @categories = Category.main_categories
  end

	def sub_categories
		@category = Category.find_by_id(params[:id])
		@sub_categories = @category.children
	end

  def new
    @category = Category.new
  end

	def new_sub_category
		@category = Category.find(params[:id])
		@sub_category = Category.new
	end

	def edit_sub_category
		@category = Category.find(params[:id])
		@sub_category = Category.find(params[:s_id])
	end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(params[:category])
		if @category.save
			redirect_to admin_categories_path, :notice => 'Category was successfully created.'
		else
			render :action => "new"
		end
  end

	def create_sub_category
		@category = Category.find(params[:id])
    @sub_category = Category.new(params[:category])
		if @sub_category.save
			redirect_to sub_categories_admin_categories_path(:id => @category.id), :notice => 'Sub Category was successfully created.'
		else
			render :action => "new_sub_category"
		end
  end

  def update
    @category = Category.find(params[:id])
		if @category.update_attributes(params[:category])
			redirect_to admin_categories_path, :notice => 'Category was successfully updated.'
		else
			render :action => "edit"
		end
	end

	def update_sub_category
    @category = Category.find(params[:id])
		@sub_category = Category.find(params[:s_id])
		if @sub_category.update_attributes(params[:category])
			redirect_to sub_categories_admin_categories_path(:id => @category.id ), :notice => 'Sub Category was successfully updated.'
		else
			render :action => "edit_sub_category"
		end
	end

	def destroy

		@category = Category.find(params[:id])
		@category.destroy
		redirect_to admin_categories_url
	end
end
