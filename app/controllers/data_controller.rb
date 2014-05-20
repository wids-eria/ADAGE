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


  def get_events_by_group
    if params[:app_token] != nil
      client = Client.where(app_token: params[:app_token]).first
    end


    if client != nil

      since = time_range_to_epoch(params[:time_range])
      game_name = client.implementation.game.name

      keys = params[:events_list]
      if keys == nil
        keys = AdaData.with_game(game_name).distinct(:key)
      end

      users = Array.new
      if params[:group] != nil
        group = Group.where(code: params[:group]).first
        if group != nil
          users = group.user_ids
        end
      end

      if params[:game_id].nil? or params[:game_id].empty? 
        @data = AdaData.with_game(game_name).where(:timestamp.gt => since).in(key: keys).in(user_id: users)
      else
        @data = AdaData.with_game(game_name).where(game_id: params[:game_id]).where(:timestamp.gt => since).in(key: keys).in(user_id: users)
      end
    end


    @result = Hash.new
    @result['data'] = @data
    respond_with @result


  
  end


  def get_sorted_and_limited_events
    
    
    if params[:app_token] != nil
      client = Client.where(app_token: params[:app_token]).first
    end


    if client != nil

      since = time_range_to_epoch(params[:time_range])
      game_name = client.implementation.game.name

      if params[:user_id].nil? or params[:user_id].empty?
        @data = AdaData.with_game(game_name).where(:timestamp.gt => since).where(key: params[:key]).desc(params[:field_name]).skip(params[:start]).limit(params[:limit])
      else
        @data = AdaData.with_game(game_name).where(:timestamp.gt => since).where(key: params[:key]).where(user_id: params[:user_id]).desc(params[:field_name]).skip(params[:start]).limit(params[:limit])
      end
    end


    @result = Hash.new
    @result['data'] = @data
    respond_with @result


  end


  def get_events

    if params[:app_token] != nil
    client = Client.where(app_token: params[:app_token]).first
    end


    if client != nil

      since = time_range_to_epoch(params[:time_range])
      game_name = client.implementation.game.name

      keys = params[:events_list]
      if keys == nil
        keys = AdaData.with_game(game_name).distinct(:key)
      end

      if params[:game_id].nil? or params[:game_id].empty? 
        @data = AdaData.with_game(game_name).where(:timestamp.gt => since).in(key: keys)
      else
        @data = AdaData.with_game(game_name).where(game_id: params[:game_id]).where(:timestamp.gt => since).in(key: keys)
      end
    end


    @result = Hash.new
    @result['data'] = @data
    respond_with @result

  end

  def get_game_ids
    
    if params[:app_token] != nil
      client = Client.where(app_token: params[:app_token]).first
    end

    if client != nil

      since = time_range_to_epoch(params[:time_range])
      game_name = client.implementation.game.name
      
      @game_ids = AdaData.with_game(game_name).where(:timestamp.gt => since).distinct(:game_id)

    end

    @results = Hash.new
    @results['data'] = @game_ids
    respond_with @game_ids


  end

  def data_selection
    
    
    if params[:graph_params] != nil
      @graph_params = GraphParams.new(params[:graph_params])
    else
      @graph_params = GraphParams.new
    end

    if params[:app_token] != nil
      client = Client.where(app_token: params[:app_token]).first
      @graph_params.app_token = params[:app_token]
    else
      puts @graph_params.app_token
      client = Client.where(app_token: @graph_params.app_token).first
    end

    @keys = Array.new
    @fields = Array.new
    if client != nil
    

      @game = client.implementation.game
      
      @keys = AdaData.with_game(@game.name).distinct(:key)

      if @graph_params.key != nil
        @fields = AdaData.with_game(@game.name).where(key: @graph_params.key).first.attributes.keys
      end
    
    end


  end

  def real_time_chart
    @url = params[:url]
    @graph_params = session[:graph_params]

    if @graph_params.graph_type.include?('value over time')
      @title = @graph_params.key + " : " + @graph_params.field_name + " over time" 
    end

  end


  def field_values
    

    if params[:app_token] != nil
      client = Client.where(app_token: params[:app_token]).first
    end


    if client != nil
      @game_version = client.app_token
      @game_name = client.implementation.game.name
      unless params[:time_range].nil? or params[:time_range].empty?
        since = time_range_to_epoch(params[:time_range])
      else
        since = time_range_to_epoch('all') 
      end
    

      map = %Q{
        function(){
          var data = {};
          data[this.timestamp] = this[field_name];
          emit(this.user_id,data);
        }
      }

      reduce = %Q{

        function(key,values){
          var results = {};

          values.forEach(function(value){
           
            for(var k in value) { 
              results[k] =  value[k];
            }            

          });

          return results;
        }
      }


      current_milliseconds = (Time.now.to_f * 1000).to_i
      scope = {since: since.to_i, field_name: params[:field_name]}
     
      unless params[:game_id].nil? or params[:game_id].empty?
        first_time = AdaData.with_game(@game_name).order_by(:timestamp.asc).where(game_id: params[:game_id]).first.timestamp
        logs = AdaData.with_game(@game_name).order_by(:timestamp.asc).where(game_id: params[:game_id]).where(key: params[:key]).where(:timestamp.gt => first_time ).map_reduce(map,reduce).out(inline:1).scope(scope)
      else
        logs = AdaData.with_game(@game_name).order_by(:timestamp.asc).where(key: params[:key]).where(:timestamp.gt => since.to_s).map_reduce(map,reduce).out(inline:1).scope(scope)
      end



      @data_group = DataGroup.new
      logs.each do |l|
        @user = User.find(l["_id"].to_i)
        if l["value"] != nil
          @data_group.add_to_group(l["value"], @user)
        end
      end 
      
      @chart_info = @data_group.to_rickshaw
      respond_to do |format|
        format.json {render :json => @chart_info.to_json}
        format.html {render}
        format.csv { send_data @data_group.to_csv, filename: client.implementation.game.name+"_"+current_user.player_name+".csv" }
      end

    
    else
      puts "CLIENT NOT FOUND!"
    end



  end


  def session_times

    if params[:app_token] != nil
      client = Client.where(app_token: params[:app_token]).first
    end

    if client.nil?
      return
    end


    @game = client.implementation.game
    
    @user_ids = params[:user_ids]
    unless params[:game_id].nil? or params[:game_id].empty?
      @user_ids = AdaData.with_game(@game.name).where(game_id: params[:game_id]).distinct(:user_id).uniq
    end

    if params[:time_range] != nil
      since = time_range_to_epoch(params[:time_range])
      if @user_ids.nil?
        @user_ids = AdaData.with_game(@game.name).where(:timestamp.gt => since).distinct(:user_id).uniq
      end
    end
    
    @users = User.where(id: @user_ids).order(:id)


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
   
    #check version and redirect to older api point is this is an older data spec. 
    log = AdaData.with_game(@game.name).only(:_id,:adage_version).where(:adage_version.exists=>true).first

    if log.nil?
      redirect_to session_logs_data_path, :params => params, :game_id => @game.id
      return
    end

    logs = AdaData.with_game(@game.name).order_by(:timestamp.asc).in(user_id: @user_ids).only(:timestamp,:user_id,:session_token).map_reduce(map,reduce).out(inline:1)

    puts logs.count

    sessions_played = 0
    total_session_length = 0
    last_user = -1
    index = -1

    session_time = Hash.new
    logs.each do |log|
      log_user = log["_id"]["user_id"].to_i
      if(log_user != last_user)
        #If the log is for a different user add to data_groups and initalize variables for the new user
        session_time[log_user] = Hash.new
        last_user = log_user
        index += 1
      end

      start_time = log["value"]["start"]
      end_time = log["value"]["end"]

      if start_time.is_a? String
        start_time = start_time.to_i
        end_time = end_time.to_i
      end

      start_time = Time.at(start_time).to_i
      end_time = Time.at(end_time).to_i
      minutes = (end_time - start_time)/60000
      session_time[log_user][start_time] = minutes

      total_session_length += minutes
      sessions_played += 1

    end

    @users.each do |u|
       @data_group.add_to_group(session_time[u.id], u, 'bar')
    end

    @playtimes = @data_group.to_chart_js
    @rickshaw = @data_group.to_rickshaw
    respond_to do |format|
      format.json {render :json => @rickshaw.to_json}
      format.html {render}
      format.csv { send_data @data_group.to_csv, filename: @game.name+"_participant_sessions.csv" }
    end

  
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
          start_time = log["value"]["start"]
          end_time = log["value"]["end"]

          if start_time.is_a? String
            start_time = start_time.to_i
            end_time = end_time.to_i
          end

          start_time = Time.at(start_time).to_i
          end_time = Time.at(end_time).to_i
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
    @rickshaw = @data_group.to_rickshaw
    respond_to do |format|
      format.json {render :json => @rickshaw.to_json}
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
          #render :json => data

          send_data data.to_json, filename: @game.name+'.json'
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


end
