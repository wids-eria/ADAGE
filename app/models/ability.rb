class Ability
  include CanCan::Ability
 
  def initialize(user)
    user ||= User.new # guest user
    
    can :read, AdaData do |data|
      data.user_id == user.id
    end
    
    if user.role? :admin
      can :manage, :all
    elsif user.role? :player
      can :read, AdaData do |data|
        data.user_id == user.id
      end
      can :read, User do |a_user|
        user == a_user
      end
    end
    
  end
end