Fabricator(:user) do
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password "pass1234"
end
