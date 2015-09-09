class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    cannot :manage, :all

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

      can :read, Game do |game|
        game.groups.each do |group|
          if group.users.include? user
            true
            break
          end
        end
      end

      can :manage, ParticipantRole do |p_role|
        user.role?(ResearcherRole.where(game_id: p_role.game.id).first)
      end
      
      can :manage, Organization do |org|
        OrganizationRole.where(user_id: user,organization_id: org,name:"admin").count == 1
      end

      can :read, Organization do |org|
        OrganizationRole.where(user_id: user,organization_id: org,name:["admin","teacher","student"]).count == 1
      end

      can :read, Group, Group.joins(:users).where('users.id' => user) do |group|
        group.users.include? user
      end

      can :manage, Group, Group.joins(:owners).where('users.id' => user) do |group|
        group.owners.include? user
      end

    end
   end
end
