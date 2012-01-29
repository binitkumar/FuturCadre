class SearchController < ApplicationController

  def get_regions
    obj_region= params[:obj]
    @country = Country.find_by_id(params[:country_id])
    @regions = @country.regions
    render :json => {:html => render_to_string(:partial => '/shared/regions', :locals => {:object_collection => obj_region})}.to_json
  end

  def get_cities
    obj_city = params[:obj]
    @region = Region.find_by_id(params[:region_id])
    @cities = @region.cities
    render :json => {:html => render_to_string(:partial => '/shared/cities', :locals => {:object_collection => obj_city})}.to_json
  end

  def search
    @jobs = Job.search(params)
    render :json => {:html => render_to_string(:partial => '/search/search_results')}.to_json
  end

  def get_sub_categories
    @category = Category.find(params[:id])
    if @category.parent_id == nil
      if @category.children.present?
        @sub_categories = @category.children
      end
      @jobs = @category.jobs
    else
      #@sub_categories = @category.children.jobs
      @sub_categories = @category.children
    end
    render :json => {:html => render_to_string(:partial => '/search/sub_categories')}.to_json
  end

  def categories_jobs_list
    #		@sub_category = Category.find(params[:id])
    #		@jobs = @sub_category.jobs
    @jobs = Job.all
    render :json => {:html => render_to_string(:partial => '/search/search_results')}.to_json
  end

  def get_browse_by
    @categories = Category.main_categories
    @companies = CompanyInformation.all
    @regions = Region.find_all_by_country_id([24, 82])

    case params[:by].to_s
      when "category"
        html = render_to_string(:partial => '/search/by_category')
      when "region"
        html = render_to_string(:partial => '/search/by_region')
      when "company"
        html = render_to_string(:partial => '/search/by_company')
    end
    render :json => {:html => html}.to_json
  end

  def check_user_name
    @user = User.find_by_name(params[:name])
    if @user.present?
      render :json => {:success => false}.to_json
    else
      render :json => {:success => true}.to_json
    end
  end

  def get_jobs_by_company
    @company = CompanyInformation.find(params[:id])
    @jobs = @company.profile.user.created_jobs
    render :json => {:html => render_to_string(:partial => '/search/company_jobs')}.to_json
  end

  def jobs_list
    		@sub_category = Category.find(params[:id])
    		@jobs = @sub_category.jobs
   # @jobs = Job.all      (closed during debugginh)
    render :json => {:html => render_to_string(:partial => '/search/search_results')}.to_json
  end

  def get_jobs_by_region
    @region = Region.find(params[:id])
    @jobs = Job.find_all_by_region_id(@region.id)
    render :json => {:html => render_to_string(:partial => '/search/region_jobs')}.to_json
  end

end
