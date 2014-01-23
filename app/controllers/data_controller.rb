class DataController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json, :csv
  protect_from_forgery :except => :create
  layout 'blank'

  def index
    @data = AdaData.page params[:page]
    authorize! :read, @data
    respond_with @data
  end


  def heatmap
    if params[:level] != nil
      @data = AdaData.with_game(params[:gameName]).where(level: params[:level]).where(:created_at.gt => params[:since]).where(key: params[:key]).where(schema: params[:schema])
    else
      @data = AdaData.with_game(params[:gameName]).where(:created_at.gt => params[:since]).where(key: params[:key]).where(schema: params[:schema])
    end
    respond_to do |format|
      format.json { render :json => @data }
    end
  end

  def session_logs
    @game = Game.find(params[:game_id])
    @users = User.where(id: params[:user_ids])
    @average_time = 0
    @session_count = 0
    @data_group = DataGroup.new

    if @users.count > 0
      @users.each do |user|
          session_times = user.session_information(@game.name)
          @data_group.add_to_group(session_times, user)
          session_times.each do |key, value|
            @average_time = @average_time + value
          end
          @session_count = @session_count + session_times.count
      end
      if @session_count > 0
        @average_time = @average_time/@session_count
      end
    end

    @playtimes = @data_group.to_chart_js

    respond_to do |format|
      format.json {render :json => @data_group.to_json}
      format.html {render}
      format.csv { send_data @data_group.to_csv, filename: @game.name+"_participant_sessions.csv" }
    end
  end

  def context_logs
    @game = Game.find(params[:game_id])
    @users = User.where(id: params[:user_ids])
    @data_group = DataGroup.new

    if AdaData.with_game(@game.name).first.respond_to?('ADAVersion')
      if AdaData.with_game(@game.name).first.ADAVersion.include?('drunken_dolphin')
        logs =  AdaData.with_game(@game.name).in(user_id: params[:user_ids]).any_of(:ada_base_types.in => ['ADAGEContextStart','ADAGEContextEnd'])
      else
        logs =  AdaData.with_game(@game.name).in(user_id: params[:user_ids]).any_of(:ada_base_type.in => ['ADAUnitStart','ADAUnitEnd'])
      end

      context_logs = logs.entries

      last_user = nil
      contexts = Hash.new(0)
      context_stack = Array.new
      context_logs.each do |q|
        if last_user.nil? or q["user_id"] != last_user

          if last_user != nil
            @data_group.add_to_group(contexts, User.find(q["user_id"]))
          end
          last_user = q["user_id"]
          contexts = Hash.new(0)
          context_stack = Array.new
        end

        start = false
        if q.ADAVersion.include?('drunken_dolphin')
          if q.ada_base_types.include?('ADAGEContextStart')
            start = true
          end
        else
          if q.ada_base_type.include?('ADAUnitStart')
            start = true
          end
        end
        if start
          unless context_stack.include?(q.name)
            context_stack << q.name
            contexts[q.name+'_start'] = contexts[q.name+'_start'] + 1
          end
        else
          if context_stack.include?(q.name)
            context_stack.delete(q.name)
            contexts[q.name+'_end'] = contexts[q.name+'_end'] + 1
            if q.respond_to?('success')
              if q.success == true
                contexts[q.name+'_success'] = contexts[q.name+'_success'] + 1
              else
                contexts[q.name+'_fail'] = contexts[q.name+'_fail'] + 1
              end
            end
          end
        end
      end

    end
=begin
    if @users.count > 0
      @users.each do |user|
        contexts = user.context_information(@game.name)
        @data_group.add_to_group(contexts, user)
      end
    end
=end

    @chart_info = @data_group.to_chart_js
    respond_to do |format|
      format.json {render :json => @data_group.to_json}
      format.html {render}
      format.csv { send_data @data_group.to_csv, filename: @game.name+"_participant_sessions.csv" }
    end
  end

  def data_by_version
    @game = Game.find_by_name(params[:gameName])
    authorize! :read, @game
    @user_ids = params[:user_ids]
    respond_to do |format|
      format.csv {
        out = CSV.generate do |csv|
          @user_ids.each do |id|
            user = User.find(id)
            if user.present?
              user.data_to_csv(csv, @game.name, params[:version])
            end
          end
        end

        send_data out, filename: @game.name+'_'+ params[:version]+'.csv'
      }
      format.json {
        data = AdaData.with_game(params[:gameName]).where(schema: params[:version]).in(user_id: params[:user_ids] )
        render :json => data
      }
    end
  end

  def export
    @game = Game.find_by_name(params[:gameName])
    authorize! :read, @game
    @user_ids = params[:user_ids]
    respond_to do |format|
      format.csv {
        out = CSV.generate do |csv|
          @user_ids.each do |id|
            user = User.find(id)
            if user.present?
              user.data_to_csv(csv, @game.name)
            end
          end
        end

        send_data out, filename: @game.name+'.csv'
      }
      format.json {
          data = AdaData.with_game(@game.name).in(user_id: @user_ids)
          render :json => data
      }
    end
  end

  def show
    @data = AdaData.find(params[:id])
    authorize! :read, @data
    respond_with @data
  end

  def create

    @data = []
    error = false
    if params[:data]
      params[:data].each do |datum|
        data = AdaData.new(datum)
        data.user = current_user
        if data.save
          @data << data
        else
          error = true
        end
      end
    else
     error = true
    end

    return_value = {}
    if error
      status = 400
    else
      status = 201
    end
    respond_to do |format|
      format.all { redirect_to :root, :status => status}
    end
  end


  def find_tenacity_player
  end


  def tenacity_player_stats

    player_name = params[:player_name]

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

    minds = @user.data('Tenacity-Meditation').asc(:timestamp)
    crystals = @user.data('KrystalsOfKaydor').asc(:timestamp)
    timers = @user.data('App Timer').asc(:timestamp)


    if minds.count > 0
      sessions = minds.distinct(:session_token)
      sessions.each do |token|
        session_logs = minds.where(session_token: token)
        if session_logs.first.schema.include?('PRODUCTION-05-17-2013')
          end_time =  DateTime.strptime(session_logs.last.timestamp, "%m/%d/%Y %H:%M:%S").to_time.localtime
          start_time = DateTime.strptime(session_logs.first.timestamp, "%m/%d/%Y %H:%M:%S").to_time.localtime
          hash = start_time.month.to_s + "/" + start_time.day.to_s  + "/" + start_time.year.to_s
          minutes = ((end_time - start_time)/1.minute).round
          if @tenacity_sessions[hash] != nil
            @tenacity_sessions[hash] =  @tenacity_sessions[hash] + minutes
          else
            @tenacity_sessions[hash] = minutes
          end
          @tenacity_time = @tenacity_time + minutes
        end
      end
      @tenacity_count = sessions.count
    end

    if crystals.count > 0
      sessions = crystals.distinct(:session_token)
      sessions.each do |token|
        session_logs = crystals.where(session_token: token)
        if session_logs.first.schema.include?('PRODUCTION-05-29-2013')
          end_time =  DateTime.strptime(session_logs.last.timestamp, "%m/%d/%Y %H:%M:%S").to_time.localtime
          start_time = DateTime.strptime(session_logs.first.timestamp, "%m/%d/%Y %H:%M:%S").to_time.localtime
          hash = start_time.month.to_s  + "/" + start_time.day.to_s  + "/" + start_time.year.to_s
          minutes = ((end_time - start_time)/1.minute).round
          if @crystals_sessions[hash] != nil
            @crystals_sessions[hash] =  @crystals_sessions[hash] + minutes
          else
            @crystals_sessions[hash] = minutes
          end

          @crystals_time = @crystals_time + minutes
        end
      end
      finish_count = crystals.where(name: 'CompleteAllTheQuests').count
      finish_count = crystals.where(name: 'Do all the quests').count
      @crystals_count = sessions.count
      @crystals_finish_count = finish_count

    end

    if timers.count > 0
      start_time = nil
      end_time = nil
      last_key = ''
      timers.each do |log|
        if log.key == 'LogStart'
          last_key = log.key
          start_time =  DateTime.strptime(log.timestamp, "%m/%d/%Y %H:%M:%S").to_time.localtime
        elsif log.key == 'LogStopNormal'
          if last_key != log.key
            end_time =  DateTime.strptime(log.timestamp, "%m/%d/%Y %H:%M:%S").to_time.localtime
            hash = start_time.month.to_s  + "/" + start_time.day.to_s  + "/" + start_time.year.to_s
            minutes = ((end_time - start_time)/1.minute).round
            if @timer_sessions[hash] != nil
              @timer_sessions[hash] =  @timer_sessions[hash] + minutes
            else
              @timer_sessions[hash] = minutes
            end

            @timer_time = @timer_time + minutes
          end
          last_key = log.key

        else
          puts 'unknown log type!'
        end
      end
      @timer_count = @timer_sessions.count

    end

  end

end
