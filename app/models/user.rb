class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
		:recoverable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
	attr_accessor :role_id
	before_save :set_role

	has_and_belongs_to_many :roles

	has_many :created_jobs, :as => :employer, :class_name => "Job"

	def set_role
		#self.roles << Role.find_by_id(self.role_id) if self.new_record?
		#self.roles << Role.find_by_id(4) if self.new_record?
	end

end
