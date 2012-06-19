class User < ActiveRecord::Base
  has_mailbox
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
  has_many :comments
  has_many :questions
  has_many :event_users
  has_many :events, :through => :event_users
  has_many :created_events, :as => :owner, :class_name => "Event"
  has_many :sent_invitations, :class_name => 'EventUser', :foreign_key => 'sender_id'

  #has_many :applied_jobs
  has_many :applied_jobs
  has_many :jobs, :through => :applied_jobs

  has_many :stored_jobs, :as => :employer, :class_name => "AppliedJob"

  #belongs_to :event_user

  has_many :theses_users
  has_many :theses, :through => :theses_users
  has_many :created_theses, :as => :owner, :class_name => "Thesis"
  has_many :selected_profiles, :as => :employer, :class_name => "EmployerProfile"

  has_many :project_users
  has_many :projects, :through => :project_users
  has_many :created_projects, :as => :owner, :class_name => "Project"
  has_many :sent_invitations, :class_name => 'ProjectUser', :foreign_key => 'sender_id'
  has_many :created_news, :as => :owner, :class_name => "News"

  has_many :manage_projects, :as => :manager, :class_name => "Group"
  has_many :events

  belongs_to :package
  attr_accessible :package_id, :avail_jobs, :avail_search

  has_many :package_users

  #has_many :packages, :through => :packages_users

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

  def group_manager?
    roles.include?(Role.find_all_by_name("group_manager"))
  end

  def is_member(id, type)
    if type == "group"
      self.groups.include?(Group.find_by_id(id))
    else
      self.projects.include?(Project.find_by_id(id))
    end
  end

  def has_applied(job_id)
    self.applied_jobs.include?(AppliedJob.find_by_job_id(job_id))
  end
end

