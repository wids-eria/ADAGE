namespace :abilities do
  desc 'Safely create admin/player/teacher/researcher roles'
  task :create => :environment do
    if Role.where(name: 'admin').empty?
      Role.create(name: 'admin')
    end
    if Role.where(name: 'player').empty?
      Role.create(name: 'player')
    end
    if Role.where(name: 'teacher').empty?
      Role.create(name: 'teacher')
    end
    if Role.where(name: 'researcher').empty?
      Role.create(name: 'researcher')
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
end
