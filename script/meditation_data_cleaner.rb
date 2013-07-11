require 'csv'
require 'progressbar'

class StandardColumns
  attr_accessor :touch_types, :stages

  def initialize
    self.touch_types = AdaData.where(key: 'TenTouchEvent', schema: 'BETA-TESTING-3-14-2013').distinct(:touchType)
    self.stages = AdaData.where(key: 'TenStageStart', schema: 'BETA-TESTING-3-14-2013').distinct(:name)
  end
end

class ShowAllPlayers
  def run
    players = User.select{|u| u.data.count > 0}
    puts players.count
    bar = ProgressBar.new 'players', players.count
    
    csv = CSV.open('csv/meditation/meditation_totals.csv', 'w')
    s_columns = StandardColumns.new
    csv << column_header + s_columns.touch_types + s_columns.stages
    players.each do |user|
        MeditatingPlayer.new(user).run csv, s_columns
        bar.inc
    end
    bar.finish
    csv.close

  end
  
  def column_header
    ["player", "total session time", "average session time", 'stage starts', 'stage completes', 'total breath cycles', 'successful cycles', 'unsuccessful cycles', 'total touches', 'pre count', 'post count', 'pre average', 'post average']
  end

end

class MeditatingPlayer
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def duration_to_seconds(duration)
    numbers = duration.split(":").map(&:to_i)
    (numbers[0]*60) + numbers[1]
  end

  def run csv, s_columns

    data = user.data.where(schema: 'BETA-TESTING-3-14-2013')
  
    if data.count == 0
     return;
    end 
    #find this players stage packages
    
    stage_starts = data.where(key: 'TenStageStart')
    stage_completes = data.where(key: 'TenStageComplete')
    breath_cycles = data.where(key: 'TenBreathCycleEnd')
    cycles_by_success = breath_cycles.map{|x| x}.group_by{|y| y.success}
    touches = data.where(key: 'TenTouchEvent').map{ |x| x}.group_by{ |y| y.touchType}
    stage_by_type = stage_starts.map{|x| x}.group_by{|y| y.name}
    pre_post = data.where(key: 'TenSelfAssessment').map{|x| x}.group_by{ |y| y.isPrePost}
    pre_count = 0
    post_count = 0
    if pre_post['Pre'] != nil
      pre_count = pre_post['Pre'].count
    end
    if pre_post['Post'] != nil
      post_count = pre_post['Post'].count
    end
    successful_count = 0
    unsuccessful_count = 0
    if cycles_by_success[true] != nil
      successful_count = cycles_by_success[true].count
    end
    if cycles_by_success[false] != nil
      unsuccessful_count = cycles_by_success[false].count
    end

    pre_avg = data.where(isPrePost: 'Pre').avg(:selfAssessmentValue)

    post_avg = data.where(isPrePost: 'Post').avg(:selfAssessmentValue)

    total_session_time = 0
    session_times = stage_completes.map{ |x| x.timeInLevel}
    session_times.each do |time| 
      total_session_time += duration_to_seconds(time)
    end
    average_session_time = 0
    if session_times.count > 0
      average_session_time = total_session_time/session_times.count
    end

    touch_totals = Array.new
    total_t = 0
    s_columns.touch_types.each do |type|
      if touches[type] != nil
        total_t += touches[type].count
        touch_totals << touches[type].count
      else
        touch_totals << 0
      end
    end
    standard_columns = [user.player_name, total_session_time, average_session_time, stage_starts.count, stage_completes.count, breath_cycles.count, successful_count, unsuccessful_count, total_t, pre_count, post_count, pre_avg, post_avg] 

    
    stage_totals = Array.new
    s_columns.stages.each do |type|
      if stage_by_type[type] != nil
        stage_totals << stage_by_type[type].count
      else
        stage_totals << 0
      end
    end


    csv << standard_columns + touch_totals + stage_totals
  end

  def stage_names
    ["Tutorial_Alpha", "Greek Ruins", "Stairway", "Egyptian Ruins"] 
  end

end

ShowAllPlayers.new.run
