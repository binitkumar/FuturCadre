module ApplicationHelper
  def escape_single_quotes(x)
    return x.gsub(/'/, "\\\\'")
  end

  def profile_image
    unless current_user.profile.blank?
      current_user.profile.assets.each do |asset|
        if asset.content_type == "profile_image"
          return asset
        else
          return false
        end
      end
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
    puts "user", user_image.inspect
    user = User.find(user_image)
    unless user.profile.blank?
      user.profile.assets.each do |asset|
        puts "aaaaaaaaaaa"
        if asset.content_type == "profile_image"
          return asset
       end
      end
    end

  end

end
