class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    alias_action :update, :destroy, to: :update_destroy

    if user.admin?
      can :manage, :all
    elsif user.member?
      can :read, :all
      can :show, User
      can :update, User, id: user.id
      can :create, Comment
      can :update_destroy, Comment, user_id: user.id
    else
      can :read, Product
      can :read, Comment
    end
  end
end
