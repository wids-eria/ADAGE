# when we come across objectiveaction or a populate, store
# when come across grid destroy, cell/tissue collect (or empty for zombie
# organ) look back at stored objectiveaction/populate to determine on/off task.
# and look at populate to
require 'csv'

class FarFailureReport
  attr_accessor :reports

  def initialize
    self.reports = []
  end


  def run
    #users = User.where(id: 296..480)
    users = User.where(consented: true)

    users.select{|u| u.data.where(gameName: 'ProgenitorX').count > 0}.each do |user|
      puts user.player_name
      reports << IndividualReport.new(user).run
    end

    spit_that_shit_out
  end


  def spit_that_shit_out
    header = reports.collect(&:keys).flatten.uniq.sort

    CSV.open("csv/all_the_totals.csv", "w") do |csv|
      csv << header
      reports.each do |report|
        csv << header.collect{|col| report[col] || 0}
      end
    end
  end
end

class IndividualReport
  attr_accessor :current_objective
  attr_accessor :current_populate
  attr_accessor :user
  attr_accessor :data

  def initialize(user)
    self.user = user
    self.data = {}
  end


  def run
    user.data.each do |data|
      parse_that_shit(data)
    end

    data["player"]    = user.player_name
    data["timestamp"] = user.data.last.timestamp

    return data
  end


  def parse_that_shit(data)
    case data.key
    when "ObjectiveActionData"
      objective_action(data)
    when "PopulateGridData"
      populate_grid(data)
    when "GridDestroyData"
      grid_destroy(data)
    when "TissueCollectionData"
      tissue_collect(data)
    when "CellCollectionData"
      cell_collect(data)
    when "ToolUseData"
      organ_collect(data)
    end
  end


  def objective_action(data)
    case data.action
    when 'added'
      self.current_objective = data
      increment("objective added count")
    when 'completed'
      increment("objective completed count")
    end
  end


  def populate_grid(data)
    self.current_populate = data
  end



  # GRID DESTROY ########################
  #
  def grid_destroy(data)
    if self.current_objective
      if populate_on_task?
        increment("on task destroy")
        increment("on task #{fill_column(data.fillType)} destroy")
        increment("on task obj#{objective_number(self.current_objective)} destroy")
        increment("on task obj#{objective_number(self.current_objective)} #{fill_column(data.fillType)} destroy")
      else
        increment("off task destroy")
        increment("off task #{fill_column(data.fillType)} destroy")
        increment("off task obj#{objective_number(self.current_objective)} destroy")
        increment("off task obj#{objective_number(self.current_objective)} #{fill_column(data.fillType)} destroy")
      end
    end
  end


  def populate_on_task?
    if self.current_objective
      allowed_populates = case self.current_objective.objective
                          when 'Collect 10 *Red Mesoderm Cells*'
                            ['IPS1', 'IPS2']
                          when 'Collect 10 *Blue Ectoderm Cells*'
                            ['IPS1', 'IPS2','Fibroblast']
                          when 'Create a *Tissue*'
                            ['Tissue1']
                          when 'Create a second *Tissue*'
                            ['Tissue2']
                          when 'Create *Green Endoderm Cells* & build the final tissue'
                            ['IPS1', 'IPS2', 'Tissue3', 'Fibroblast']
                          when 'Locate *Necrotic Zombie Tissue*'
                            ['Organ']
                          when 'Create a replacement Heart *Tissue*'
                            ['Tissue4', 'Fibroblast']
                          when 'Find and replicate remaining *Necrotic Zombie Tissue*'
                            ['IPS1', 'IPS2', 'Tissue5', 'Fibroblast', 'Organ']
                          end


      if allowed_populates.include? self.current_populate.fillType
        increment("on task populates")
        increment("on task #{fill_column(self.current_populate.fillType)} populates")

        increment("on task obj#{objective_number(self.current_objective)} populates")
        increment("on task obj#{objective_number(self.current_objective)} #{fill_column(self.current_populate.fillType)} populates")
        return true
      else
        increment("off task populates")
        increment("off task #{fill_column(self.current_populate.fillType)} populates")

        increment("off task obj#{objective_number(self.current_objective)} populates")
        increment("off task obj#{objective_number(self.current_objective)} #{fill_column(self.current_populate.fillType)} populates")
        return false
      end
    end
  end



  # CELL COLLECT #######################
  #
  def cell_collect(data)
    populate_on_task?

    if self.current_objective
      allowed_collects = case self.current_objective.objective
                         when "Collect 10 *Red Mesoderm Cells*"
                           ["Meso"]
                         when "Collect 10 *Blue Ectoderm Cells*"
                           ["IPS1","Ecto"]
                         when "Create *Green Endoderm Cells* & build the final tissue"
                           ["IPS1","Endo"]
                         when "Create a replacement Heart *Tissue*"
                           ["Meso"]
                         when "Find and replicate remaining *Necrotic Zombie Tissue*"
                           ["IPS1", "Meso"]
                         else
                           []
                         end
      if allowed_collects.include? data.cellType
        increment("succesful collects")
        increment("succesful cell collects")
        increment("succesful #{fill_column(data.cellType)} cell collects")

        increment("succesful obj#{objective_number(self.current_objective)} collects")
        increment("succesful obj#{objective_number(self.current_objective)} cell collects")
        increment("succesful obj#{objective_number(self.current_objective)} #{fill_column(data.cellType)} cell collects")
      else
        increment("unsuccesful collects")
        increment("unsuccesful cell collects")
        increment("unsuccesful #{fill_column(data.cellType)} cell collects")

        increment("unsuccesful obj#{objective_number(self.current_objective)} collects")
        increment("unsuccesful obj#{objective_number(self.current_objective)} cell collects")
        increment("unsuccesful obj#{objective_number(self.current_objective)} #{fill_column(data.cellType)} cell collects")
      end
    end
  end



  # TISSUE COLLECT #######################
  #
  def tissue_collect(data)
    populate_on_task?

    if self.current_objective
      allowed_collects = case self.current_objective.objective
                         when "Create a *Tissue*"
                           ["Tissue1"]
                         when "Create a second *Tissue*"
                           ["Tissue2"]
                         when "Create *Green Endoderm Cells* & build the final tissue"
                           ["Tissue3"]
                         when "Create a replacement Heart *Tissue*"
                           ["Tissue4"]
                         when "Find and replicate remaining *Necrotic Zombie Tissue*"
                           ["Tissue5"]
                         else
                           []
                         end
      if allowed_collects.include? data.tissueType
        increment("succesful collects")
        increment("succesful tissue collects")
        increment("succesful #{fill_column(data.tissueType)} tissue collects")

        increment("succesful obj#{objective_number(self.current_objective)} collects")
        increment("succesful obj#{objective_number(self.current_objective)} tissue collects")
        increment("succesful obj#{objective_number(self.current_objective)} #{fill_column(data.tissueType)} tissue collects")
      else
        # this does not appear to happen
        #
        increment("unsuccesful collects")
        increment("unsuccesful tissue collects")
        increment("unsuccesful #{fill_column(data.tissueType)} tissue collects")

        increment("unsuccesful obj#{objective_number(self.current_objective)} collects")
        increment("unsuccesful obj#{objective_number(self.current_objective)} tissue collects")
        increment("unsuccesful obj#{objective_number(self.current_objective)} #{fill_column(data.tissueType)} tissue collects")
      end
    end
  end



  # ORGAN COLLECT #######################
  #
  def organ_collect(data)
    if self.current_populate.respond_to?('fillType') == false
      if data.toolName == "Collect"
        if data.tileCoord["cellType"] == "Empty"
          increment("succesful collects")
          increment("succesful organ collects")
          increment("succesful obj#{objective_number(self.current_objective)} organ collects")
        else data.tileCoord["cellType"] != "ScanPoint"
          increment("unsuccesful collects")
          increment("unsuccesful organ collects")
          increment("unsuccesful obj#{objective_number(self.current_objective)} organ collects")
        end
      end
    end
  end



  # SUPPORT METHODS #####################
  #
  def increment(field)
    self.data[field] ||= 0
    self.data[field]  += 1
  end


  def fill_column(fill_type)
    fill_name = {'IPS1'    => 'IPS',
                 'IPS2'    => 'IPS',
                 'Ecto'    => 'Ecto',
                 'Endo'    => 'Endo',
                 'Meso'    => 'Meso',
                 'Organ'   => 'Organ',
                 'Tissue1' => 'Tissue',
                 'Tissue2' => 'Tissue',
                 'Tissue3' => 'Tissue',
                 'Tissue4' => 'Tissue',
                 'Tissue5' => 'Tissue',
                 'Fibroblast' => 'Fibroblast'
    }[fill_type]
    raise "dont know #{fill_type}" if fill_name == nil
    fill_name
  end


  def increase_multiple_counts
    raise 'write a test that 5 increments and passing the 5 to this create the same buckets'
  end


  def log_event
    raise 'add every event into an array, compare this to array of unfiltered events to find missing ones'
  end


  def objective_number(data)
    case data.objective
    when 'Collect 10 *Red Mesoderm Cells*'
      1
    when 'Collect 10 *Blue Ectoderm Cells*'
      2
    when 'Create a *Tissue*'
      3
    when 'Create a second *Tissue*'
      4
    when 'Create *Green Endoderm Cells* & build the final tissue'
      5
    when 'Locate *Necrotic Zombie Tissue*'
      6
    when 'Create a replacement Heart *Tissue*'
      7
    when 'Find and replicate remaining *Necrotic Zombie Tissue*'
      8
    else
      raise 'unknown objective'
    end
  end

end

FarFailureReport.new.run
