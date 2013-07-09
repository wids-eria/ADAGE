class DataController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    @data = AdaData.page params[:page]
    authorize! :read, @data
    respond_with @data
  end


  def recent
    @data = AdaData.where(gameName: "APA:Tracts").where(:created_at.gt => params[:since]).where(key: "Colon Position")
    respond_to do |format|
      format.json { render :json => @data }
    end
  end

  def heatmap
    if params[:level] != nil
      @data = AdaData.where(gameName: params[:gameName]).where(level: params[:level]).where(:created_at.gt => params[:since]).where(key: params[:key]).where(schema: params[:schema])
    else
      @data = AdaData.where(gameName: params[:gameName]).where(:created_at.gt => params[:since]).where(key: params[:key]).where(schema: params[:schema])
    end
    respond_to do |format|
      format.json { render :json => @data }
    end
  end

  def show
    @data = AdaData.find(params[:id])
    authorize! :read, @data
    respond_with @data
  end

  def create
    @data = []
    if params[:data]
      params[:data].each do |datum|
        data = AdaData.new(datum)
        data.user = current_user
        data.save
        @data << data
      end
    end

    return_value = {}
    respond_with return_value, :location => ''
  end

  def find_tenacity_player
  end


  def tenacity_player_stats

    player_name = params[:player_name]
    puts player_name

    @user = User.where(player_name: player_name).first
    if @user == nil
      flash[:error] = 'Player not found'
      redirect_to :back
      return
    end

    @tenacity_count = 0
    @crystals_count = 0
    @crystals_finish_count = 0
    @timer_count = 0
    @tenacity_time = 0
    @crystals_time = 0
    @timer_time = 0
    @tenacity_sessions = Hash.new
    @crystals_sessions = Hash.new
    @timer_sessions = Hash.new
    
    minds = @user.data.where(gameName: 'Tenacity-Meditation')
    crystals = @user.data.where(gameName: 'KrystalsOfKaydor')
    timers = @user.data.where(gameName: 'App Timer') 

    if minds.count > 0
      sessions = minds.distinct(:session_token)
      sessions.each do |token|
        session_logs = minds.where(session_token: token)
        end_time =  DateTime.strptime(session_logs.last.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        start_time = DateTime.strptime(session_logs.first.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        @tenacity_sessions[start_time.to_s] = ((end_time - start_time)/1.minute).round 
        @tenacity_time = @tenacity_time + @tenacity_sessions[start_time.to_s]
      end
      @tenacity_count = sessions.count
    end

    if crystals.count > 0
      sessions = crystals.distinct(:session_token)
      sessions.each do |token|
        session_logs = crystals.where(session_token: token)
        end_time =  DateTime.strptime(session_logs.last.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        start_time = DateTime.strptime(session_logs.first.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        @crystals_sessions[start_time.to_s] = ((end_time - start_time)/1.minute).round 
        @crystals_time = @crystals_time + @crystals_sessions[start_time.to_s]
      end
      finish_count = crystals.where(name: 'CompleteAllTheQuests').count
      finish_count = crystals.where(name: 'Do all the quests').count
      @crystals_count = sessions.count
      @crystals_finish_count = finish_count

    end

    if timers.count > 0
      start_time = nil
      end_time = nil
      timers.each do |log|
        if log.key == 'LogStart'
          start_time =  DateTime.strptime(log.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
        elsif log.key == 'LogStopNormal'
          end_time =  DateTime.strptime(log.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
          @timer_sessions[start_time.to_s] = ((end_time - start_time)/1.minute).round 
          @timer_time = @timer_time + @timer_sessions[start_time.to_s]
        else
          end_time =  DateTime.strptime(log.timestamp, "%m/%d/%Y %H:%M:%S").to_time 
          @timer_sessions[start_time.to_s + ' Non Normal completion'] = ((end_time - start_time)/1.minute).round 
          @timer_time = @timer_time + @timer_sessions[start_time.to_s]
        end
      end
      @timer_count = @timer_sessions.count 

    end

  end
end
