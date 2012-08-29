require 'csv'

def setObjective(data, objective)
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

def init_player_totals()
  all_cycle = Hash.new
 # all_cycle['IPS1 started'] = 0
  all_cycle['IPS1 success'] = 0
  #all_cycle['cell started'] = 0
  all_cycle['Meso success'] = 0
  all_cycle['Ecto success'] = 0
  all_cycle['Endo success'] = 0
  all_cycle['cell success'] = 0
 # all_cycle['tissue started'] = 0
  all_cycle['tissue success'] = 0
 # all_cycle['organ started'] = 0
  all_cycle['organ success'] = 0
  all_cycle['total collects'] = 0
  all_cycle['total destroys'] = 0
  all_cycle['total unsuccessful collects'] = 0
  all_cycle['total successful collects'] = 0
  return all_cycle
end

def init_cycle_totals()
  cycle_totals = Hash.new
  cycle_totals['destroys'] = 0
  cycle_totals['unsuccessful collects'] = 0
  return cycle_totals
end


#users = User.where(id: 296..480)
#users = User.where(id: 365)
users = User.where(consented: true)
CSV.open('csv/totals.csv', 'w') do |totals|
users.each do |d|
  u = d.data.where(gameName: "ProgenitorX").where(schema: "4-18-2012")
  if u.count != 0 
  CSV.open('csv/' + d.email+'.csv', 'w') do |csv|
    puts d.email
    puts d.id.to_s()
    objective = ['IPS1']
    all_cycle = init_player_totals()
    cycle_totals = init_cycle_totals()
    organGrid = false;
    timestamp = 0;
    cycle_name = ''
    u.each do |e|
      timestamp = e.timestamp
      cycle_type = ''
      if e.key == 'ObjectiveActionData'
        objective = setObjective(e, objective)
        #puts e.objective
        #puts e.action
        #puts objective
      end
      #puts e.key
      case e.key
      when 'PopulateGridData'
        #Beginning a cycle reset the counts
        if e.respond_to?('fillType')
          if e.fillType == 'Fibroblast'
            #all_cycle['IPS1 started'] += 1
            cycle_name = 'Fibroblast'
            organGrid = false
          end
          if e.fillType == 'IPS1' || e.fillType == 'IPS2'
            #all_cycle['cell started'] += 1
            cycle_name = e.fillType
            organGrid = false
          end
        end
        if e.gridType == 'tissue'
          #all_cycle['tissue started'] += 1
          cycle_name = 'tissue'
          organGrid = false
        end
        if e.gridType == 'organ'
          #all_cycle['organ started'] += 1
          cycle_name = 'organ'
          organGrid = true
        end
        if cycle_totals[cycle_name + 'populate'] == nil
          cycle_totals[cycle_name + 'populate'] = 1
        else
          cycle_totals[cycle_name + 'populate'] += 1
        end
        if all_cycle[cycle_name + 'populate'] == nil
          all_cycle[cycle_name + 'populate'] = 1
        else
          all_cycle[cycle_name + 'populate'] += 1
        end


      when 'ToolUseData'
        if e.toolName == 'Collect' && organGrid == true
          #puts e.tileCoord['cellType']
          #if e.tileCoord['cellType'] == 'ScanPoint'
            csv << ['cycle type','organ']
            csv << cycle_totals.keys
            csv << cycle_totals.values
            cycle_totals = init_cycle_totals()
            all_cycle['organ success'] += 1
            organGrid = false
          #end
        #else
         # if cycle_totals[e.toolName] == nil
          #  cycle_totals[e.toolName] = 1
          #else
            #cycle_totals[e.toolName] += 1
          #end
        end
      when 'GridDestroyData'
        #count this as a fails
        cycle_totals['destroys'] += 1
       if all_cycle[cycle_name + ' destroys'] == nil
          all_cycle[cycle_name + ' destroys'] = 1
        else
          all_cycle[cycle_name + ' destroys'] += 1
        end 
        all_cycle['total destroys'] += 1
        if all_cycle[cycle_name + ' destroys'] == nil
          all_cycle[cycle_name + ' destroys'] = 1
        else
          all_cycle[cycle_name + ' destroys'] += 1
        end 

      when 'CellCollectionData'
        #end of a cell cycle was this a success?
        all_cycle['total collects'] += 1
        cycle_totals['collect' + all_cycle['total collects'].to_s()] = e.cellType + ' ' + e.tileCoords.count.to_s()
        csv << ['cycle type', e.cellType, 'objectives', objective]
        csv << cycle_totals.keys
        csv << cycle_totals.values
        cycle_totals = init_cycle_totals()
        #puts e.cellType + ' success'
        if objective.include?(e.cellType)
          all_cycle[e.cellType + ' success'] += 1
          if e.cellType != 'IPS1'
            all_cycle['cell success'] += 1
          end
          organGrid = false
          all_cycle['total successful collects'] += 1
        elsif
          all_cycle['total unsuccessful collects'] += 1
          cycle_totals['unsuccessful collects'] += 1
        end
      when 'TissueCollectionData'
        all_cycle['total collects'] += 1
        csv << ['cycle type', e.tissueType,'objectives', objective]
        csv << cycle_totals.keys
        csv << cycle_totals.values
        cycle_totals = init_cycle_totals()
        if objective.include?(e.tissueType)
          all_cycle['tissue success'] += 1
          organGrid = false
          all_cycle['total successful collects'] += 1 
        end
        #end of a tissue cycle was this a success?
      end
    
    end
  csv << ['cycle type', 'not completed']
  csv << cycle_totals.keys
  csv << cycle_totals.values
  csv << all_cycle.keys
  csv << all_cycle.values
  totals << ['email', 'time'] + all_cycle.keys 
  totals << [d.email, timestamp] + all_cycle.values
  end
end
end
end


