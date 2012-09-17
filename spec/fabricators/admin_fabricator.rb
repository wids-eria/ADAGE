Fabricator(:admin, from: :user) do
  player_name { sequence(:player_name) {|i| "admin#{i}"} }
  email { sequence(:email) { |i| "admin#{i}@example.com" } }
  password "pass1234"
  roles [(Role.where(name: 'admin').first || Role.create(name: 'admin')),
         (Role.where(name: 'player').first || Role.create(name: 'player'))]
end
