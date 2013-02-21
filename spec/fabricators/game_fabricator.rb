Fabricator(:game) do
  name 'CoolGameBro'
  after_create { |game, transients| Fabricate(:schema, name: "Playsquad", game: game) }
end
