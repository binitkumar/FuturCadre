module ApplicationHelper
  def escape_single_quotes(x)
    return x.gsub(/'/, "\\\\'")
  end

  def profile_image
    unless current_user.profile.blank?
      current_user.profile.assets.each do |asset|
        if asset.content_type == "profile_image"
          return asset
        end
      end
      return false
    end
  end

  def comment_image(comment)
    unless comment.user.profile.blank?
      comment.user.profile.assets.each do |asset|
        if asset.content_type == "profile_image"
          return asset
        end
      end
    end
  end

  def user_image(user_image)
    user = User.find_by_id(user_image.id)
    unless user.profile.blank?
      user.profile.assets.each do |asset|
        if asset.content_type == "profile_image"
          return asset
        end
      end
      return false
    end

  end

end
