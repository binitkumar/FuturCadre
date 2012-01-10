class Question < ActiveRecord::Base
  belongs_to :question_category
  has_many :group_questions
  has_many :group, :through => :group_questions
end
