class JobsController < ApplicationController

	def show
    @job = Job.find_by_id(params[:id])
	end

	def details
		@job = Job.find_by_id(params[:id])
		render :json => {:html => render_to_string(:partial => '/jobs/details')}.to_json
	end

end
