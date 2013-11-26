namespace :abilities do
  desc 'Safely create admin, player and developer roles'
  task :create => :environment do
    if Role.where(name: 'admin').empty?
      Role.create(name: 'admin')
    end
    if Role.where(name: 'player').empty?
      Role.create(name: 'player')
    end
    if Role.where(name: 'developer').empty?
      Role.create(name: 'developer')
    end

  end

  desc 'Add the player roles to all users'
  task :add_roles_to_users => :environment do
    player = Role.where(name: 'player').first

    User.all.each do |user|
      user.roles << player unless user.roles.include?(player)
      user.save
    end
  end

  desc 'Add developer roles to existing games'
  task :create_developer_roles => :environment do
    Game.all.each do |game|
      if game.developer_role.nil?
        puts 'creating developer role for ' + game.name
        DeveloperRole.create(name: game.name, game: game)
      end
      
    end
  end

end
