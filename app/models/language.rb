class Language < ActiveRecord::Base
has_many :job_languages
has_many :jobs, :through => :job_languages
end
