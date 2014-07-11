require 'csv'

file = "#{Rails.root}/script/users.csv"

users = User.where(consented: true)

CSV.open( file, 'w' ) do |writer|
  writer << ["Player Name","User ID"]
  users.each do |user|
    writer << [user.player_name, user.id]
  end

end