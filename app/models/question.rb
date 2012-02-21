class Question < ActiveRecord::Base
  belongs_to :question_category
  belongs_to :user
  belongs_to :group
  has_many :answers
end
