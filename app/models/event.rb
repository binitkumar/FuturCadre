class Event < ActiveRecord::Base
  #has_many :user_events
  #has_many :users, :through => :user_events
  #has_one :photo , :as => :imageable
  belongs_to :group
  belongs_to :user
end
