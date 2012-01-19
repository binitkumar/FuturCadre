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
    end
  end
end
