class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    #user.roles.each { |role| send(role) }
    if user.roles.size == 0
      can :read, :all #for guest without roles
    end
    if user.webmaster?
        can :manage, :all

    end
    if user.employer?
      can :manage, Job
      can :manage, EmployerController
    end
    if user.job_seeker?
      can :new_application, :apply_job , Job
    end

    #def webmaster
    #  can :manage, :all
    #end
    #
    #def employer
    #
    #end
    #
    #def job_seeker
    #
    #end
    #
    #def group_manager
    #
    #end

  end
end
