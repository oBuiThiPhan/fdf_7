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
      can [:read, :create], Comment
    else
      can :read, Product
      can :read, Comment
    end
  end
end
