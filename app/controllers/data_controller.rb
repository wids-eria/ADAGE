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


  def get_events

    if params[:app_token] != nil
    client = Client.where(app_token: params[:app_token]).first
    end


    if client != nil

      since = time_range_to_epoch(params[:time_range])

      @data = AdaData.with_game(client.implementation.game.name).where(:timestamp.gt => since).in(key: params[:event_name])
    end


    @result = Hash.new
    @result['data'] = @data
    respond_with @result

  end

  def session_logs
    @game = Game.find(params[:game_id])
    @users = User.where(id: params[:user_ids]).order(:id)

    map = %Q{
      function(){
        var key = {user_id: this.user_id,session: this.session_token};
        var data = {start:this.timestamp,end:this.timestamp};
        emit(key,data);
      }
    }

    reduce = %Q{
      function(key,values){
        var results = {start: null,end:0};

        values.forEach(function(value){
            if(results.start == null) results.start = value.start;
            results.end = value.end;
        });

        return results;
      }
    }

    @data_group = DataGroup.new
    @average_time = 0
    @session_count = 0
    #Check for the ADAVersion for compatability before all the processing
    log = AdaData.with_game(@game.name).only(:_id,:ADAVersion).where(:ADAVersion.exists=>true).first

    unless log.nil?
      drunken_dolphin = log.ADAVersion.include?('drunken_dolphin')
      logs = AdaData.with_game(@game.name).order_by(:timestamp.asc).in(user_id: params[:user_ids]).only(:ADAVersion,:timestamp,:user_id,:session_token).where(:ADAVersion.exists=>true).map_reduce(map,reduce).out(inline:1)

      sessions_played = 0
      total_session_length = 0
      last_user = -1
      index = -1

      session_time = Hash.new
      logs.each do |log|
        log_user = log["_id"]["user_id"].to_i
        if(log_user != last_user)
          #If the log is for a different user add to data_groups and initalize variables for the new user
          @data_group.add_to_group(session_time, @users[index])
          session_time = Hash.new
          last_user = log_user
          index += 1
        end


          if drunken_dolphin
            start_time = Time.at(log["value"]["start"]).to_i
            end_time = Time.at(log["value"]["end"]).to_i
          else
            start_time = DateTime.strptime(log["value"]["start"], "%m/%d/%Y %H:%M:%S").to_time.to_i
            end_time = DateTime.strptime(log["value"]["end"], "%m/%d/%Y %H:%M:%S").to_time.to_i
          end
          minutes = (end_time - start_time)/1.minute.round
          session_time[start_time] = minutes

          total_session_length += minutes
          sessions_played += 1


        #add the last user
        @data_group.add_to_group(session_time, @users[index])
      end

      @average_time = total_session_length/sessions_played
      @session_count = sessions_played
      @total_time = total_session_length
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
    @users = User.where(id: params[:user_ids]).order(:id)
    @data_group = DataGroup.new

    map = %Q{
      function(){
        var data = {}

        var append = "";
        if(this.ADAVersion == "drunken_dolphin"){
          if(this.ada_base_types.indexOf("ADAGEContextStart") > -1) append = "start";
          if(this.ada_base_types.indexOf("ADAGEContextEnd") > -1 ) append = "end";
        }else{
          if(this.ada_base_type.indexOf("ADAUnitStart") > -1) append = "start";
          if(this.ada_base_type.indexOf("ADAUnitEnd") > -1) append = "end";
        }

        if(append != "") data[this.name+"_"+append] = 1;

        if(this.success != null){
          append = "fail";
          if(this.success){
            append = "success";
          }

          data[this.name+"_"+append] = 1;
        }
        emit(this.user_id,data);
      }
    }

    reduce = %Q{
      function(key,values){
        var results = {};

        function merge(a,b){
          for(var k in b){
            if(!b.hasOwnProperty(k)){
              continue;
            }
            a[k] = (a[k] || 0) + b[k];
          }
        }

        values.forEach(function(value){
          merge(results,value);
        });
        return results;
      }
    }

    log = AdaData.with_game(@game.name).exists(ADAVersion: true).first

    if log
      if log.ADAVersion == 'drunken_dolphin'
        logs = AdaData.with_game(@game.name).in(user_id: params[:user_ids]).exists(ADAVersion: true).only(:user_id,:ada_base_types,:ADAVersion).any_of(:ada_base_types.in => ['ADAGEContextStart','ADAGEContextEnd']).map_reduce(map,reduce).out(inline:1)
      else
       logs = AdaData.with_game(@game.name).in(user_id: params[:user_ids]).exists(ADAVersion: true).only(:user_id,:ada_base_type,:ADAVersion).any_of(:ada_base_type.in => ['ADAUnitStart','ADAUnitEnd']).map_reduce(map,reduce).out(inline:1)
      end

      index = 0
      logs.each do |log|
        @data_group.add_to_group(log["value"], @users[index])
        index += 1
      end
    end

    @chart_info = @data_group.to_chart_js
    respond_to do |format|
      format.json {render :json => @data_group.to_json}
      format.html {render}
      format.csv { send_data @data_group.to_csv, filename: @game.name+"_participant_sessions.csv" }
    end
  end

  def data_by_version
    @game = Game.where('lower(name) = ?', params[:gameName].downcase).first
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
    @game = Game.where('lower(name) = ?', params[:gameName].downcase).first
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

    minds = @user.data('Tenacity-Meditation').asc(:timestamp).entries
    crystals = @user.data('KrystalsOfKaydor').asc(:timestamp).entries
    timers = @user.data('App Timer').asc(:timestamp).entries


    if minds.count > 0
      sessions = @user.data('Tenacity-Meditation').distinct(:session_token)
      sessions.each do |token|
        session_logs = minds.select{ |d| d.session_token.include?(token) } #minds.where(session_token: token)
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
      sessions = @user.data('KrystalsOfKaydor').distinct(:session_token)
      crystals = crystals.entries
      sessions.each do |token|
        session_logs = crystals.select{ |d|  d.session_token.include?(token) }
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
      crystals_quests = crystals.select{ |d| d.key.include?('KoKObjectiveEnd') }
      finish_count = crystals_quests.select{ |d| d.name.include?('Do all the quests')}.count
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
