class News < ActiveRecord::Base
  belongs_to :user
  has_one :photo, :as => :imageable
  has_one :rating, :as => :rateable

end
