class GroupsController < ApplicationController

  #before_filter :authenticate_user!

  def index
       @groups = Group.all
    respond_to do |format|
    format.html  # index.html.erb
    format.json  { render :json => @groups }
  end
  end
  def details
      @group = Group.find(params[:id])
      render :json => {:html => render_to_string(:partial => '/groups/details')}.to_json

  end

end
