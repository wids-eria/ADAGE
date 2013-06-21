Fabricator(:game) do
  name 'CoolGameBro'
  after_create { |game, transients| Fabricate(:implementation, name: "Playsquad", game: game) }
end
