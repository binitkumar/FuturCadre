class AppliedJob < ActiveRecord::Base
  belongs_to :user
  belongs_to :job
  #belongs_to :applied_job
end
