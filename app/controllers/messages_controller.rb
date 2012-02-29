class MessagesController < ApplicationController
 before_filter :authenticate_user!

  def index
    @employer = current_user
    @messages = current_user.inbox
  end

  def show
    @employer = current_user
    @message  = current_user.inbox.find_by_id(params[:id])
    @employer.inbox.find_by_id(params[:id]).mark_as_read

  end

end
