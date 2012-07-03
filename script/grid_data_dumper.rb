users = User.all
users.each do |d|
  u = d.data.where(gameName: "ProgenitorX").where(schema: "4-18-2012")
  if u.count != 0 
    CSV.open('grid_data/' + d.email+'.csv', 'cw') do |csv|
      u.each do |e|
        timestamp = e.timestamp
        cycle_type = ''
        if e.key == 'GridStateData'
          objective = setObjective(e, objective)
        end
     end
    end
  end
end

