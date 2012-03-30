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
      return false
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

  def pro_image(user_image)
    user = Profile.find_by_user_id(user_image.user_id)
    unless user.blank?
      user.assets.each do |asset|
        if asset.content_type == "profile_image"
          return asset
        end
      end
      return false
    end
  end

=begin
  def collect_shared_error_messages(target)
    targets        = []
    error_messages = []
    if target.kind_of?(Array)
      target.collect { |t| targets << t }
    else
      targets << target
    end
    targets.each do |target|
      target.errors.full_messages.collect { |msg| error_messages << msg } if target.errors.any?
    end
    error_messages
  end
=end

end
