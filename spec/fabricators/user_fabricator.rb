Fabricator(:user) do
  player_name { sequence(:player_name) { |i| "username#{i}" } }
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password "pass1234"
end

Fabricator(:user_with_data, from: :user) do
  after_save { Fabricate(:AdaData, user_id: user.id) }
end 

