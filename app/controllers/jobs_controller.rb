class JobsController < ApplicationController

	def show
    @job = Job.find_by_id(params[:id])
	end

	def details
		@job = Job.find_by_id(params[:id])
		render :json => {:html => render_to_string(:partial => '/jobs/details')}.to_json
  end



  def new
    @job= Job.new
    @skill = Skill.new(params[:skills])
    @responsibility = Responsibility.new(params[:responsibilities])

  end

  def create_job
    @job = Job.new(params[:job])
    @job.update_attributes(:employer_id => current_user.id, :country_id=> params[:country_id], :region_id=>params[:region_id],
                           :city_id     =>params[:city_id], :category_id => params[:category_id])
    if @job.save
        redirect_to(@job, :notice => 'Job was successfully created.')
    else
      render :action => "new"
    end
  end

end
