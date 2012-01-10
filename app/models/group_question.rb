class GroupQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :group
end
