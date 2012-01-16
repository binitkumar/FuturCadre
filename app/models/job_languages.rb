class JobLanguages < ActiveRecord::Base
  belongs_to :job
  belongs_to :language
end
