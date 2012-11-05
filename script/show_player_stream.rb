class ShowAllPlayerStreams
  def run
    users = User.where(id: 296..480)

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

    good_data.each do |data_point|
      display data_point
    end
  end


  def thing_we_care_about? data_point
    white_list.include?(data_point.key) || (data_point.key == "ToolUseData" && data_point.toolName == "Collect" && data_point.tileCoord["cellType"] == "Empty")
  end


  def white_list
     ["PopulateGridData", "GridDestroyData", "TissueCollectionData", "CellCollectionData"]
  end


  def display data_point
    puts "---" if data_point.key == "PopulateGridData"
    puts "#{data_point.key}#{" "*(21-data_point.key.length)}#{data_point.attributes.except(*stuff_we_dont_care_about)}"
  end


  def stuff_we_dont_care_about
    ["_id", "created_at", "updated_at", "schema", "session_token", "key", "gameName", "user_id", "tileCoords", "turnLimit", "fromTemplate", "currentTurn", "phLevel"]
  end
end

ShowAllPlayerStreams.new.run
