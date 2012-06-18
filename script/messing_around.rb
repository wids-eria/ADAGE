require 'csv'

users = User.where(id: 296..480)
CSV.open("ProgenitorXBasicTotals.csv", "w") do |csv|
  csv << ["email","populate","cell collect", "tissue collect", "grid destroy"]
  validUsers = 0
  users.each do |d|
    u = d.data
    populate = 0
    cell = 0
    tissue = 0
    destroy = 0
    u.each do |e|
      if e.key == "PopulateGridData"
        #csv << [e.timestamp, e.key, e.fillType, e.user_id]
        populate = populate + 1
      end
      if e.key == "CellCollectionData"
        #csv << [e.timestamp, e.key, e.cellType, e.user_id]
        cell = cell + 1
      end
      if e.key == "TissueCollectionData"
        #csv << [e.timestamp, e.key, e.tissueType, e.user_id]
        tissue = tissue + 1
      end
      if e.key == "ObjectiveActionData"
        #csv << [e.timestamp, e.key, e.objective, e.user_id]
      end
       if e.key == "GridDestroyData"
          #csv << [e.timestamp, e.key, e.fillType, e.turnLimit, e.user_id]
          destroy = destroy + 1
      end
    end
    if u.count > 0
      csv << [d.email, populate, cell, tissue, destroy]
      validUsers = validUsers + 1
    end
  end
  csv << ["total users", validUsers]
end