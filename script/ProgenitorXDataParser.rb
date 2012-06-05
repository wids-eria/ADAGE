require 'csv'

def setObjective(data, objective)
  case data.action
  when "added"
    case data.objective
    when "Collect 10 *Red Mesoderm Cells*"
      return ["Meso"]
    when "Collect 10 *Blue Ectoderm Cells*"
      return ["IPS1","Ecto"]
    when "Create a *Tissue*"
      return ["Tissue1"]
    when "Create a second *Tissue*"
      return ["Tissue2"]
    when "Create *Green Endoderm Cells* & build the final tissue"
      return ["IPS1","Endo", "Tissue3"]
    when "Locate *Necrotic Zombie Tissue*"
      return ["zombie"]
    when "Create a replacement Heart *Tissue*"
      return ["Meso", "Tissue4"]
    when "Find and replicate remaining *Necrotic Zombie Tissue*"
      return ["IPS1", "Meso", "Tissue5", "zombie"]
    else
      return objective
    end
  when "completed"
    return ["none"]
  else
    return objective
  end      
end



users = User.where(id: 296..480)
#users = User.where(id: 365)
CSV.open("csv/totals.csv", "w") do |totals|
users.each do |d|
  u = d.data
  if u.count != 0
  CSV.open("csv/" + d.email+".csv", "w") do |csv|
    objective = ["IPS1"]
    all_cycle = Hash.new
    all_cycle["IPS1 started"] = 0
    all_cycle["IPS1 success"] = 0
    all_cycle["cell started"] = 0
    all_cycle["Meso success"] = 0
    all_cycle["Ecto success"] = 0
    all_cycle["Endo success"] = 0
    all_cycle["cell success"] = 0
    all_cycle["tissue started"] = 0
    all_cycle["tissue success"] = 0
    all_cycle["organ started"] = 0
    all_cycle["organ success"] = 0
    cycle_totals = Hash.new
    cycle_totals["destroys"] = 0
    organGrid = false;
    timestamp = 0;
    u.each do |e|
      timestamp = e.timestamp
      cycle_type = ""
      if e.key == "ObjectiveActionData"
        objective = setObjective(e, objective)
        #puts e.objective
        #puts e.action
        #puts objective
      end
      #puts e.key
      case e.key
      when "PopulateGridData"
        #Beginning a cycle reset the counts
        if e.fillType == "Fibroblast"
          all_cycle["IPS1 started"] += 1
          organGrid = false
        end
        if e.fillType == "IPS1" || e.fillType == "IPS2"
          all_cycle["cell started"] += 1
          organGrid = false
        end
        if e.gridType == "tissue"
          all_cycle["tissue started"] += 1
          organGrid = false
        end
        if e.gridType == "organ"
          all_cycle["organ started"] += 1
          organGrid = true
        end
      when "ToolUseData"
        if e.toolName == "Collect" && organGrid == true
          #puts e.tileCoord["cellType"]
          #if e.tileCoord["cellType"] == "ScanPoint"
            csv << ["cycle type","organ"]
            csv << cycle_totals.keys
            csv << cycle_totals.values
            cycle_totals.clear
            cycle_totals["destroys"] = 0
            all_cycle["organ success"] += 1
            organGrid = false
          #end
        else
          if cycle_totals[e.toolName] == nil
            cycle_totals[e.toolName] = 1
          else
            cycle_totals[e.toolName] += 1
          end
        end
      when "GridDestroyData"
        #count this as a fails
        cycle_totals["destroys"] += 1
      when "CellCollectionData"
        #end of a cell cycle was this a success?
        if objective.include?(e.cellType)
          csv << ["cycle type", e.cellType]
          csv << cycle_totals.keys
          csv << cycle_totals.values
          cycle_totals.clear
          cycle_totals["destroys"] = 0
          #puts e.cellType + " success"
          all_cycle[e.cellType + " success"] += 1
          if e.cellType != "IPS1"
            all_cycle["cell success"] += 1
          end
          organGrid = false
        end
      when "TissueCollectionData"
        if objective.include?(e.tissueType)
          csv << ["cycle type", e.tissueType]
          csv << cycle_totals.keys
          csv << cycle_totals.values
          cycle_totals.clear
          cycle_totals["destroys"] = 0
          all_cycle["tissue success"] += 1
          organGrid = false
        end
        #end of a tissue cycle was this a success?
      end
    
    end
  csv << ["cycle type", "not completed"]
  csv << cycle_totals.keys
  csv << cycle_totals.values
  csv << all_cycle.keys
  csv << all_cycle.values
  totals << ["email", "time"] + all_cycle.keys 
  totals << [d.email, timestamp] + all_cycle.values
  end
end
end
end


