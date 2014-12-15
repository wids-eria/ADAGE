class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    cannot :manage, AdaData
    cannot :manage, User
    cannot :manage, Game
    cannot :manage, Group

    if user.role? Role.find_by_name('admin')
      can :manage, :all
      Rack::MiniProfiler.authorize_request
    elsif user.role? Role.find_by_name('player')
      can :create, AdaData
      can :read, AdaData do |data|
        data.user_id == user.id
      end
      can :read, User do |a_user|
        user == a_user
      end

      if user.role? Role.find_by_name('developer')
        can :create, Game
        can [:read,:update,:create], Group
      end

      if user.role? Role.find_by_name('researcher')
       can [:read,:update,:create], Group
      end

      can :manage, Game do |game|
        r_role = ResearcherRole.where(game_id: game.id).first
        d_role = DeveloperRole.where(game_id: game.id).first

        if d_role.present? and r_role.present?
          user.role?(r_role) ||  user.role?(d_role)
        end
      end

      #If the user is just a player remove the manage Game abilities.
      unless user.role? Role.find_by_name('developer') or user.role? Role.find_by_name('researcher')
        cannot :manage, Game
      end

      can :manage, ParticipantRole do |p_role|
        user.role?(ResearcherRole.where(game_id: p_role.game.id).first)
      end
    end
   end
end
