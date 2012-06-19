Fabricator(:user) do
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password "pass1234"
  roles [(Role.where(name: 'player').first || Role.create(name: 'player'))]
end
