class ThesesUser < ActiveRecord::Base
  belongs_to :thesis
  belongs_to :user

end
