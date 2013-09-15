require 'csv'

class ShowAllPlayerStreams
  def run
    users = User.where(consented: true)

    users.select{|u| u.data.count > 0}.each do |user|
      puts "#{user.player_name} #{"#" * 50}"
      ShowPlayerStream.new(user).run
    end
  end
end


class ShowPlayerStream
  attr_accessor :user

  def initialize(user)
    self.user = user
  end


  def run
    good_data = user.data.select{|data_point| thing_we_care_about? data_point }

    unless good_data.empty?
      csv = CSV.open('csv/'+user.email+'.csv','w')
    end
    good_data.each do |data_point|
      display data_point
      add_to_csv(data_point, csv)
    end
  end


  def thing_we_care_about? data_point
    white_list.include?(data_point.key) || (data_point.key == "ObjectiveActionData" && data_point.objective != "This is a *TEST* objective.")
  end


  def white_list
     ["MissionActionData", "DialogButtonData", "InvetorySelectedData", "AlmanacView", "PopulateGridData", "GridDestroyData", "TissueCollectionData", "CellCollectionData", "ToolUseData",]
  end


  def display data_point
    puts "---" if data_point.key == "PopulateGridData"
    puts "#{data_point.key}#{" "*(21-data_point.key.length)}#{data_point.attributes.except(*stuff_we_dont_care_about)}"
  end

  def add_to_csv(data_point, csv)
    info = data_point.attributes.select{|attribute| attrs_we_want? attribute}
    unless info.empty?
      puts info
      csv << info.values
    end
  end


  def stuff_we_dont_care_about
    ["_id", "created_at", "updated_at", "schema", "session_token", "key", "gameName", "user_id", "tileCoords", "turnLimit", "fromTemplate", "currentTurn", "phLevel"]
  end

  def attrs_we_want? attribute
    attr_list = ["key", "timestamp", "toolName"]
    attr_list.include?(attribute)
  end
end

ShowAllPlayerStreams.new.run
