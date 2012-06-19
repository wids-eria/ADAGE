Fabricator(:role) do
  name 'player'
end

Fabricator(:player_role, from: :role)

Fabricator(:admin_role, from: :role) do
  name 'admin'
end
