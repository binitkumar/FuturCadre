class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
		:recoverable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
	attr_accessor :role_id

	has_and_belongs_to_many :roles
	has_many :created_jobs, :as => :employer, :class_name => "Job"
	has_and_belongs_to_many :jobs
	has_one :profile
  has_and_belongs_to_many :groups



	def role
		return "webmaster" if webmaster?
		return "employer" if employer?
		return "job_seeker" if job_seeker?
	end

	def webmaster?
		roles.include?(Role.find_by_name("webmaster"))
	end

	def employer?
		roles.include?(Role.find_by_name("employer"))
	end

	def job_seeker?
		roles.include?(Role.find_by_name("job_seeker"))
	end

end
