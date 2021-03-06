class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role? :admin
      can :manage, :all
    elsif user.role? :delete_coordinator
      can :read, [Site, Address, Partner, Audit, Sector, Antenna, Comment, Complaint, Proposal, Survey]
      can :manage, [Site, Address, Partner, Audit, Sector, Antenna, Comment, Proposal]
      can :propose, [Sector]
      can :create, [Survey]
      can :update, [Survey]
    elsif user.role? :edit_coordinator
      can :read, [Site, Address, Partner, Audit, Sector, Antenna, Comment, Complaint, Proposal, Survey]
      can :update, [Site, Address, Partner, Audit, Sector, Antenna, Comment, Survey]
      can :create, [Site, Address, Partner, Audit, Sector, Antenna, Comment, Survey]
      can :manage, [Proposal]
      can :propose, [Sector]
    elsif user.role? :proposal_coordinator
      can :read, [Site, Address, Partner, Audit, Sector, Antenna, Comment, Complaint, Proposal, Survey]
      can :manage, [Proposal]
      can :propose, [Sector]
      can :create, [Survey]
      can :update, [Survey]
    elsif user.role? :complaint_coordinator
      can :read, [Site, Address, Partner, Audit, Sector, Antenna, Comment, Complaint, Survey]
      can :create, [Proposal]
      can :propose, [Sector]
      can :manage, [Survey]
    elsif user.role? :normal_user
      can :read, [Site, Address, Partner, Audit, Sector, Antenna, Comment, Complaint, Survey]
      can :create, [Proposal]
      can :propose, [Sector]
      can :create, [Survey]
      can :update, [Survey]
    else
      can :read, [Site, Address, Partner, Audit, Sector, Antenna, Comment, Complaint, Survey]
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
