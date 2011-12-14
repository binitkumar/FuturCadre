class SearchController < ApplicationController

	def get_regions
		@country = Country.find_by_id(params[:country_id])
    @regions = @country.regions
   		render :json => {:html => render_to_string(:partial => '/shared/regions')}.to_json
	end

	def get_cities
		@region = Region.find_by_id(params[:region_id])
		@cities = @region.cities
		render :json => {:html => render_to_string(:partial => '/shared/cities')}.to_json
	end

	def search
		@jobs = Job.search(params)
		render :json => {:html => render_to_string(:partial => '/search/search_results')}.to_json
	end

	def get_sub_categories
		@category = Category.find(params[:id])
		@sub_categories = @category.children
		render :json => {:html => render_to_string(:partial => '/search/sub_categories')}.to_json
	end

	def jobs_list
		#		@sub_category = Category.find(params[:id])
		#		@jobs = @sub_category.jobs
		@jobs = Job.all
		render :json => {:html => render_to_string(:partial => '/search/search_results')}.to_json
	end

	def get_browse_by
		@categories = Category.main_categories
		case params[:by].to_s
		when "category"
			html = render_to_string(:partial => '/search/by_category')
		when "region"
			html = render_to_string(:partial => '/search/by_region')
		when "company"
			html = render_to_string(:partial => '/search/by_company')
		end
		render :json => {:html => html }.to_json
	end

	def check_user_name
		@user = User.find_by_name(params[:name])
		if @user.present?
			render :json => {:success => false }.to_json
		else
			render :json => {:success => true }.to_json
		end
	end

end
