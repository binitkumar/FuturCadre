module GroupsHelper

  def join_link(group_id)
    html = ""
    if !user_signed_in?
      html << " <div class='join-group-hold'>#{link_to_function("Join Group", "join_request(#{group_id});")}</div>"
    elsif current_user.is_member(group_id) == false
      html << html << " <div class='join-group-hold'>#{link_to_function("Join Group", "join_request(#{group_id});")}</div>"
    end
  end


end