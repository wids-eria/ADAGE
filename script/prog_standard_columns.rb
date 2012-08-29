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

def setPopulationExpectation(data, objective)
  case data.action
  when 'added'
    case data.objective
    when 'Collect 10 *Red Mesoderm Cells*'
      return ['IPS1']
    when 'Collect 10 *Blue Ectoderm Cells*'
      return ['IPS1','Fibroblast']
    when 'Create a *Tissue*'
      return ['Meso']
    when 'Create a second *Tissue*'
      return ['Meso']
    when 'Create *Green Endoderm Cells* & build the final tissue'
      return ['IPS1','Endo', 'Fibroblast']
    when 'Locate *Necrotic Zombie Tissue*'
      return ['organ']
    when 'Create a replacement Heart *Tissue*'
      return ['Meso', 'Fibroblast']
    when 'Find and replicate remaining *Necrotic Zombie Tissue*'
      return ['IPS1', 'Meso', 'Fibroblast', 'organ']
    else
      return objective
    end
  when 'completed'
    return ['none']
  else
    return objective
  end      
end


def task_type(type, objective)
  if objective.include?(type)
    return 'on-task'
  else
    return 'off-task'
  end
end

def increment_totals(type, action, correct, totals)
  totals[correct + ' ' + type + ' ' + action] += 1
  totals[type + ' ' + action] += 1 
  totals[action] += 1
end

def init_player_totals()
  all_cycle = Hash.new
  all_cycle['email'] = ''
  all_cycle['timestamp'] = 0
  all_cycle['cycle type'] = ''
  all_cycle['objective'] = ''
  
  all_cycle['on-task Fibroblast populate'] = 0
  all_cycle['on-task IPS populate'] = 0
  all_cycle['on-task Endo populate'] = 0
  all_cycle['on-task Meso populate'] = 0
  all_cycle['on-task Ecto populate'] = 0
  all_cycle['on-task Tissue populate'] = 0
  all_cycle['on-task Organ populate'] = 0

  all_cycle['on-task Fibroblast collect'] = 0
  all_cycle['on-task IPS collect'] = 0
  all_cycle['on-task Endo collect'] = 0
  all_cycle['on-task Meso collect'] = 0
  all_cycle['on-task Ecto collect'] = 0
  all_cycle['on-task Tissue collect'] = 0
  all_cycle['on-task Organ collect'] = 0

  all_cycle['on-task Fibroblast destroy'] = 0
  all_cycle['on-task IPS destroy'] = 0
  all_cycle['on-task Endo destroy'] = 0
  all_cycle['on-task Meso destroy'] = 0
  all_cycle['on-task Ecto destroy'] = 0
  all_cycle['on-task Tissue destroy'] = 0
  all_cycle['on-task Organ destroy'] = 0

  all_cycle['off-task Fibroblast populate'] = 0
  all_cycle['off-task IPS populate'] = 0
  all_cycle['off-task Endo populate'] = 0
  all_cycle['off-task Meso populate'] = 0
  all_cycle['off-task Ecto populate'] = 0
  all_cycle['off-task Tissue populate'] = 0
  all_cycle['off-task Organ populate'] = 0

  all_cycle['off-task Fibroblast collect'] = 0
  all_cycle['off-task IPS collect'] = 0
  all_cycle['off-task Endo collect'] = 0
  all_cycle['off-task Meso collect'] = 0
  all_cycle['off-task Ecto collect'] = 0
  all_cycle['off-task Tissue collect'] = 0
  all_cycle['off-task Organ collect'] = 0

  all_cycle['off-task Fibroblast destroy'] = 0
  all_cycle['off-task IPS destroy'] = 0
  all_cycle['off-task Endo destroy'] = 0
  all_cycle['off-task Meso destroy'] = 0
  all_cycle['off-task Ecto destroy'] = 0
  all_cycle['off-task Tissue destroy'] = 0
  all_cycle['off-task Organ destroy'] = 0

  
  all_cycle['Fibroblast populate'] = 0
  all_cycle['IPS populate'] = 0
  all_cycle['Endo populate'] = 0
  all_cycle['Meso populate'] = 0
  all_cycle['Ecto populate'] = 0
  all_cycle['Tissue populate'] = 0
  all_cycle['Organ populate'] = 0

  all_cycle['Fibroblast collect'] = 0
  all_cycle['IPS collect'] = 0
  all_cycle['Endo collect'] = 0
  all_cycle['Meso collect'] = 0
  all_cycle['Ecto collect'] = 0
  all_cycle['Tissue collect'] = 0
  all_cycle['Organ collect'] = 0

  all_cycle['Fibroblast destroy'] = 0
  all_cycle['IPS destroy'] = 0
  all_cycle['Endo destroy'] = 0
  all_cycle['Meso destroy'] = 0
  all_cycle['Ecto destroy'] = 0
  all_cycle['Tissue destroy'] = 0
  all_cycle['Organ destroy'] = 0

  all_cycle['populate'] = 0
  all_cycle['destroy'] = 0
  all_cycle['collect'] = 0


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
tstart = 0
CSV.open('csv/totals.csv', 'w') do |totals|
all_cycle = init_player_totals()
if tstart == 0
  tstart += 1
  totals << all_cycle.keys
end
users.each do |d|
  u = d.data.where(gameName: "ProgenitorX").where(schema: "4-18-2012")
  if u.count != 0 
  start = 0
  CSV.open('csv/' + d.email+'.csv', 'w') do |csv|
    all_cycle = init_player_totals()
    cycle_totals = init_player_totals()
    if(start == 0)
      start += 1
      csv << cycle_totals.keys
    end
    puts d.email
    puts d.id.to_s()
    objective = ['IPS1']
    organGrid = false;
    timestamp = 0;
    cycle_name = ''
    u.each do |e|
      timestamp = e.timestamp
      cycle_type = ''
      if e.key == 'ObjectiveActionData'
        objective = setObjective(e, objective)
        populate_obj = setPopulationExpectation(e, objective)
        cycle_totals['objective'] = objective
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
            cycle_name = 'Fibroblast'
            organGrid = false
          end
          if e.fillType == 'IPS1' || e.fillType == 'IPS2'
            cycle_name = e.fillType
            organGrid = false
          end
        end
        if e.gridType == 'tissue'
          cycle_name = 'tissue'
          organGrid = false
        end
        if e.gridType == 'organ'
          cycle_name = 'organ'
          organGrid = true
        end
        tt = task_type(cycle_name, populate_obj)
        incrament_totals(cycle_name, 'populate', tt, all_cycle)
        incrament_totals(cycle_name, 'populate', tt, cycle_totals)

      when 'ToolUseData'
        if e.toolName == 'Collect' && organGrid == true
          #puts e.tileCoord['cellType']
          #if e.tileCoord['cellType'] == 'ScanPoint'
          tt = task_type('zombie', objective)
          incrament_totals(cycle_name, 'collect', tt, all_cycle)
          incrament_totals(cycle_name, 'collect', tt, cycle_totals)
          csv << cycle_totals.values
          cycle_totals = init_player_totals()
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
        tt = task_type(cycle_name, populate_obj)
        incrament_totals(cycle_name, 'destroy', tt, all_cycle)
        incrament_totals(cycle_name, 'destroy', tt, cycle_totals)
        csv << cycle_totals.values
        cycle_totals = init_player_totals()
        organGrid = false
      end
      when 'CellCollectionData'
        tt = task_type(e.cellType, objective)
        incrament_totals(cycle_name, 'collect', tt, all_cycle)
        incrament_totals(cycle_name, 'collect', tt, cycle_totals)
        csv << cycle_totals.values
        cycle_totals = init_player_totals()
        organGrid = false
      end
      when 'TissueCollectionData'
        tt = task_type(e.tissueType, objective)
        incrament_totals(cycle_name, 'collect', tt, all_cycle)
        incrament_totals(cycle_name, 'collect', tt, cycle_totals)
        csv << cycle_totals.values
        cycle_totals = init_player_totals()
        organGrid = false
      end
    
    end
  csv << cycle_totals.values
  csv << all_cycle.values
  #totals << all_cycle.keys 
  totals << all_cycle.values
  end
end
end
end


