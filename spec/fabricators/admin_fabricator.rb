Fabricator(:admin, from: :user) do
  email { sequence(:email) { |i| "admin#{i}@example.com" } }
  password "pass1234"
  roles [(Role.where(name: 'admin').first || Role.create(name: 'admin')),
         (Role.where(name: 'player').first || Role.create(name: 'player'))]
end
