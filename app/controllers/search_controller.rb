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
		#		@category = Category.find(params[:id])
		#		@sub_categories = @category.children
		@sub_categories = Category.all
		render :json => {:html => render_to_string(:partial => '/search/sub_categories')}.to_json
	end

	def jobs_list
		#		@sub_category = Category.find(params[:id])
		#		@jobs = @sub_category.jobs
		@jobs = Job.all
		render :json => {:html => render_to_string(:partial => '/search/search_results')}.to_json
	end

	def get_browse_by
		@categories = Category.all
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

end
