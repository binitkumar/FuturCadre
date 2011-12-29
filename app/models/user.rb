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
  #has_and_belongs_to_many :groups, :as => :member , :class_name => "Group"
  #has_many :group_users, :as => :members
  has_many :group_users
  has_many :groups, :through => :group_users
  has_many :created_groups, :as => :owner, :class_name => "Group"


  def role
    return "webmaster" if webmaster?
    return "employer" if employer?
    return "job_seeker" if job_seeker?
    return "group_manager" if group_manager?
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

  def group_manager
    roles.include?(Role.find_all_by_name("group_manager"))
  end

  def is_member(group_id)
    self.groups.include?(Group.find_by_id(group_id))
  end
end

