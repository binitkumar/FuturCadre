class SearchController < ApplicationController

  def get_regions
    unless params[:obj].blank?
      obj_region= params[:obj]
    end
    @country = Country.find_by_id(params[:country_id])
    @regions = @country.regions
    unless params[:obj].blank?
      render :json => { :html => render_to_string(:partial => '/shared/regions', :locals => { :object_collection => obj_region }) }.to_json
    end
  end

  def get_cities
    obj_city = params[:obj]
    @region  = Region.find_by_id(params[:region_id])
    @cities  = @region.cities
    render :json => { :html => render_to_string(:partial => '/shared/cities', :locals => { :object_collection => obj_city }) }.to_json
  end

  def search

    array_new = ""
    @jobs     = Job.search(params)
    @jobs.each do |job|
      array_new << job.id.to_s + ","
    end
    session[:job] = array_new
    render :json => { :html => render_to_string(:partial => '/search/search_results') }.to_json
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
    render :json => { :html => render_to_string(:partial => '/search/sub_categories') }.to_json
  end

  def categories_jobs_list
    #		@sub_category = Category.find(params[:id])
    #		@jobs = @sub_category.jobs
    @jobs = Job.all
    render :json => { :html => render_to_string(:partial => '/search/search_results') }.to_json
  end

  def get_browse_by
    @categories = Category.main_categories
    @companies  = CompanyInformation.all
    @regions    = Region.find_all_by_country_id([24, 82])

    case params[:by].to_s
      when "category"
        html = render_to_string(:partial => '/search/by_category')
      when "region"
        html = render_to_string(:partial => '/search/by_region')
      when "company"
        html = render_to_string(:partial => '/search/by_company')
    end
    render :json => { :html => html }.to_json
  end

  def check_user_name
    @user = User.find_by_name(params[:name])
    if @user.present?
      render :json => { :success => false }.to_json
    else
      render :json => { :success => true }.to_json
    end
  end

  def get_jobs_by_company
    @company = CompanyInformation.find(params[:id])
    @jobs    = @company.profile.user.created_jobs
    render :json => { :html => render_to_string(:partial => '/search/company_jobs') }.to_json
  end

  def jobs_list
    @sub_category = Category.find(params[:id])
    @jobs         = @sub_category.jobs
    # @jobs = Job.all      (closed during debugginh)
    render :json => { :html => render_to_string(:partial => '/search/search_results') }.to_json
  end

  def get_jobs_by_region
    @region = Region.find(params[:id])
    @jobs   = Job.find_all_by_region_id(@region.id)
    render :json => { :html => render_to_string(:partial => '/search/region_jobs') }.to_json
  end

  def profile_search
    flag   = false
    count  = 0
    @query = "SELECT  DISTINCT p.* FROM profiles p RIGHT OUTER JOIN education_informations ei ON p.id = ei.profile_id LEFT OUTER JOIN profession_informations ON p.id = profession_informations.profile_id where"
    unless params[:contract_type].blank?
      if params[:contract_type] !="Select from list"
        flag   = true
        count  = count + 1
        @query = @query + " p.desired_job_type like '%#{params[:contract_type]}%'"
      end
    end
    unless params[:country_id].blank?
      if params[:country_id] !="Select from list"
        flag = true
        if count == 0
          @query = @query + " p.country_id like '%#{params[:country_id]}%'"
        else
          @query = @query + "and p.country_id like '%#{params[:country_id]}%'"
        end
        count = count + 1
      end
    end
    unless params[:region_id].blank?
      if params[:region_id] !="Select from list"
        flag = true
        if count == 0
          @query = @query + " p.region_id like '%#{params[:region_id]}%'"
        else
          @query = @query + "and p.region_id like '%#{params[:region_id]}%'"
        end
        count = count + 1
      end
    end
    unless params[:city_id].blank?
      flag = true
      if count == 0
        @query = @query + " p.city_id like '%#{params[:city_id]}%'"
      else
        @query = @query + "and p.city_id like '%#{params[:city_id]}%'"
      end
      count = count + 1
    end
    unless params[:languages].blank?
      if params[:languages] !="Select from list"
        flag = true
        if count == 0
          @query = @query + " p.languages like '%#{params[:languages]  }%'"
        else
          @query = @query + "and p.languages like  '%#{params[:languages]}%'"
        end
        count = count + 1
      end
    end
    unless params[:education_level].blank?
      if params[:education_level] !="Select from list"
        flag = true
        if count == 0
          @query = @query + " ei.degree_level like '%#{params[:education_level]}%'"
        else
          @query = @query + "and ei.degree_level like '%#{params[:education_level]}%'"
        end
        count = count + 1
      end
    end
    unless params[:institute].blank?
      if params[:institute] !="Select from list"
        flag = true
        if count == 0
          @query = @query + " ei.institute_id like '%#{params[:institute]}%'"
        else
          @query = @query + "and ei.institute_id like '%#{params[:institute]}%'"
        end
        count = count + 1
      end
    end

    unless params[:category_id].blank?
      if params[:category_id] !="Select from list"
        flag = true
        if count == 0
          @query = @query + " profession_informations.category_id  like '%#{params[:category_id]}%'"
        else
          @query = @query + "and profession_informations.category_id  like '%#{params[:category_id]}%'"
        end
        count = count + 1
      end
    end

    unless params[:profession_experience].blank?
      if params[:profession_experience] !="Select from list"
        flag = true
        if count == 0
          @query = @query + " profession_informations.profession_experience   like '%#{params[:profession_experience]}%'"

        else
          @query = @query + "and profession_informations.profession_experience   like '%#{params[:profession_experience]}%'"

        end
        count = count + 1
      end
    end

    if flag == true
      @collections = Profile.find_by_sql(@query)

    else
      @collections = nil
    end
    #@collections = Profile.find_by_sql("SELECT * FROM profiles p
    #INNER JOIN education_informations ei
    #ON p.id = ei.profile_id
    #INNER JOIN profession_informations
    #ON p.id = profession_informations.profile_id
    #WHERE p.first_name like '%#{params[:first_name]}%' AND p.last_name like '%#{params[:last_name]}%'
    # AND p.country_id like '%#{params[:country_id]}%' AND p.region_id like '%#{params[:region_id]}%'
    #AND p.city_id like '%#{params[:city_id]}%' AND ei.degree_level like '%#{params[:degree_level]}%'
    #AND ei.major_subject like '%#{params[:major_subject]}%'  AND ei.institute like '%#{params[:institute]}%'
    #AND ei.year like '%#{params[:year]}%' AND profession_informations.category_id like '%#{params[:category_id]}%'
    #AND profession_informations.job_title like '%#{params[:job_title]}'
    #AND profession_informations.profession_experience like '%#{params[:profession_experience]}%'
    #AND profession_informations.profession_industry like  '%#{params[:profession_industry]}%'"
    #)

    render :json => { :html => render_to_string(:partial => '/employer/search_results'), :locals => { :collections => @collections } }.to_json
  end

  def sort_result

    jobs    = []
    new_job = session[:job].split(",")
    new_job.each do |job|
      unless job.blank?
        jobs << Job.find_by_id(job.gsub(",", ""))
      end
    end
    if params[:sort] =="Desc"
      @jobs = jobs.sort_by { |e| e[:created_at] }.reverse!
    else
      @jobs = jobs.sort_by { |e| e[:created_at] }
    end
    render :json => { :html => render_to_string(:partial => '/search/search_results') }.to_json
  end

  def sorting_box
    render :partial => '/search/sorting_box'
  end
end

