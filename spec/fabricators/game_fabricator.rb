Fabricator(:game) do
  name 'CoolGameBro'
  schemas(count: 3) { |attrs, i| Fabricate(:schema, name: "Playsquad #{i}") }
end
