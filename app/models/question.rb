class Question < ActiveRecord::Base
  belongs_to :question_category
  belongs_to :user
  has_many :group_questions
  has_many :group, :through => :group_questions
  has_many :answers
end
