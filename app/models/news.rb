class News < ActiveRecord::Base
  is_impressionable
  acts_as_commentable
  belongs_to :user
  belongs_to :news_category
  has_one :photo, :as => :imageable
  has_one :rating, :as => :rateable

  validates_presence_of :title

  protected
  def set_rating(rate)
    new_rating = self.rating.rate
    new_rating = (new_rating.to_i + rate.to_i)/2
    set_rating = self.rating.update_attributes(:rate => new_rating)
    return set_rating
  end


end

