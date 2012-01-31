class Thesis < ActiveRecord::Base
  belongs_to :thesis_category
  has_many :photos , :as => :imageable

end
