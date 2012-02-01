class Thesis < ActiveRecord::Base
    belongs_to :category
    has_one :photo, :as => :imageable
     belongs_to :owner, :class_name => "User"
    has_many :theses_users
    has_many :users , :through => :theses_users
  end


