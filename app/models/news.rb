class News < ActiveRecord::Base
  acts_as_commentable
  belongs_to :user
  belongs_to :news_category
  has_one :photo, :as => :imageable
  has_one :rating, :as => :rateable

  validates_presence_of :title

end
