class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    cannot :manage, AdaData
    cannot :manage, User
    cannot :manage, Game

    if user.role? Role.find_by_name('admin')
      can :manage, :all
    elsif user.role? Role.find_by_name('player')
      can :create, AdaData
      can :read, AdaData do |data|
        data.user_id == user.id
      end
      can :read, User do |a_user|
        user == a_user
      end

      can :manage, Game do |game|
        user.role?(ResearcherRole.where(game_id: game.id).first)
      end

      can :manage, ParticipantRole do |p_role|
        user.role?(ResearcherRole.where(game_id: p_role.game.id).first)
      end
    end


    if user.role? Role.find_by_name('researcher')
      can :read, Group
      can :update, Group
      can :create, Group
    end

   end
end
