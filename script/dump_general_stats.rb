require 'csv'
require 'progressbar'

class GeneralAdaStatistics
  def run
    total_users = User.all.count
    per_game_users = Array.new
    game_list.each do |foo|
      per_game_users << 0
    end
    users = User.all.select{|u| u.data.count > 0}
    bar = ProgressBar.new 'users', users.count
    users.each do |user|
      game_list.each_with_index do |game_name,i|
        unless user.data.where(gameName: game_name).empty?
          per_game_users[i] = per_game_users[i] + 1;
        end        
      end 
      bar.inc
    end
    bar.finish

    total_data = AdaData.all.count
    per_game_data = Array.new
    game_list.each do |foo|
      per_game_data << 0
    end

    game_list.each_with_index do |game_name, i|
      count = AdaData.where(gameName: game_name).count
      puts game_name + " " + count.to_s
      per_game_data[i] = count
    end

    per_game_users.each do |foo|
      foo = foo.to_s
    end
    per_game_data.each do |foo|
      foo = foo.to_s
    end

    csv = CSV.open('csv/GeneralAdaTotals.csv', 'w')
    csv << ['total users', total_users.to_s]
    csv << ['total data', total_data.to_s]
    csv << game_list
    csv << per_game_users
    csv << per_game_data

  end

  def game_list
    ['APA:Tracts', 'ProgenitorX', 'FairPlay', 'Pathfinder', 'kodu', 'Tenacity-Meditation']
  end

end

GeneralAdaStatistics.new.run
