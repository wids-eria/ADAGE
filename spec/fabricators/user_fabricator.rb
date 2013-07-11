Fabricator(:user) do
  player_name { sequence(:player_name) { |i| "username#{i}" } }
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password "pass1234"
end
