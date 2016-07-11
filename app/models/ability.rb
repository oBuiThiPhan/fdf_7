class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.member?
      can :read, :all
      can :show, User
      can [:edit, :update], User, id: user.id
    else
      can :read, Product
    end
  end
end
