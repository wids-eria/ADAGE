require 'csv'

def set_objective(data, objective)
  case data.action
  when 'added'
    case data.objective
    when 'Collect 10 *Red Mesoderm Cells*'
      return ['Meso']
    when 'Collect 10 *Blue Ectoderm Cells*'
      return ['IPS1','Ecto']
    when 'Create a *Tissue*'
      return ['Tissue1']
    when 'Create a second *Tissue*'
      return ['Tissue2']
    when 'Create *Green Endoderm Cells* & build the final tissue'
      return ['IPS1','Endo', 'Tissue3']
    when 'Locate *Necrotic Zombie Tissue*'
      return ['zombie']
    when 'Create a replacement Heart *Tissue*'
      return ['Meso', 'Tissue4']
    when 'Find and replicate remaining *Necrotic Zombie Tissue*'
      return ['IPS1', 'Meso', 'Tissue5', 'zombie']
    else
      return objective
    end
  when 'completed'
    return ['none']
  else
    return objective
  end      
end


def init_columns()
  all_cycle = Hash.new
  all_cycle['IPS1 started'] = 0
  all_cycle['IPS1 success'] = 0
  all_cycle['cell started'] = 0
  all_cycle['Meso success'] = 0
  all_cycle['Ecto success'] = 0
  all_cycle['Endo success'] = 0
  all_cycle['cell success'] = 0
  all_cycle['tissue started'] = 0
  all_cycle['tissue success'] = 0
  all_cycle['organ started'] = 0
  all_cycle['organ success'] = 0
  all_cycle['Collect'] = 0
  all_cycle['collect type'] = 0
  all_cycle['collect amount'] = 0
  all_cycle['destroy'] = 0
  all_cycle['unsuccessful collect'] = 0
  all_cycle['Move'] = 0
  all_cycle['Shock'] = 0
  all_cycle['GrowthFactor'] = 0
  all_cycle['Scan'] = 0
  return all_cycle
end


users = User.where(consented: true)
#users = User.where(id: 364)
#users = User.where(id: 296..480)
CSV.open('csv/progenitor_all_player_log.csv', 'w') do |csv|
  columns = init_columns()
  csv << ['log event', 'serial number', 'timestamp', 'objective', 'current cycle'] + columns.keys
  users.each do |d|
    u = d.data.where(gameName: "ProgenitorX").where(schema: "4-18-2012")
    if u.count != 0 
      objective = ['none']
      current_cycle = 'none'
      u.each do |e|
        case e.key
        when 'ObjectiveActionData'
          objective = set_objective(e, objective)
        when 'PopulateGridData'
          #Beginning a cycle reset the counts
          if e.respond_to?('fillType')
            if e.fillType == 'Fibroblast'
              columns['IPS1 started'] += 1
              organGrid = false
            end
            if e.fillType == 'IPS1' || e.fillType == 'IPS2'
              columns['cell started'] += 1
              organGrid = false
            end
            current_cycle = e.fillType
          end
          if e.gridType == 'tissue'
            columns['tissue started'] += 1
            organGrid = false
            current_cycle = 'tissue'
          end
          if e.gridType == 'organ'
            columns['organ started'] += 1
            organGrid = true
            current_cycle = 'organ'
          end
        when 'ToolUseData'
          if e.toolName == 'Collect' && organGrid == true
            csv << ['cycle type','organ']
            csv << cycle_totals.keys
            csv << cycle_totals.values
            cycle_totals = init_cycle_totals()
            columns['organ success'] += 1
            organGrid = false
          end
          if columns[e.toolName] != nil
            columns[e.toolName] += 1
          end
        when 'GridDestroyData'
          #count this as a fails
          columns['destroy'] += 1
        when 'CellCollectionData'
          #end of a cell cycle was this a success?
          columns['collect type'] = e.cellType
          columns['collect amount'] = e.tileCoords.count.to_s()
          if objective.include?(e.cellType)
            #puts e.cellType + ' success'
            columns[e.cellType + ' success'] += 1
            if e.cellType != 'IPS1'
              columns['cell success'] += 1
            end
            organGrid = false
          elsif
            columns['unsuccessful collect'] += 1
          end
        when 'TissueCollectionData'
          columns['collect type'] = e.tissueType
          if objective.include?(e.tissueType)
            columns['tissue success'] += 1
            organGrid = false
          end
          #end of a tissue cycle was this a success?
        end
        csv << [e.key, d.email, e.timestamp, objective, current_cycle] + columns.values
        columns = init_columns() 
      end
    end
  end
end


