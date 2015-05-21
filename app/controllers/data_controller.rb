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
      game_name = client.implementation.game.name

      unless params[:time_range].nil?
        since = time_range_to_epoch(params[:time_range])

        if params[:user_id].nil? or params[:user_id].empty?
          @data = AdaData.with_game(game_name).where(:timestamp.gt => since).where(key: params[:key]).desc(params[:field_name]).skip(params[:start]).limit(params[:limit])
        else
          @data = AdaData.with_game(game_name).where(:timestamp.gt => since).where(key: params[:key]).where(user_id: params[:user_id]).desc(params[:field_name]).skip(params[:start]).limit(params[:limit])
        end
      else
        @data  = AdaData.with_game(game_name).all.desc('_id')
        unless params[:key].nil?
          @data = @data.where(key: params[:key])
        end

        unless params[:user_id].nil?
          @data = @data.where(user_id: params[:user_id])
        end
        
        @data.limit(params[:limit])
      end
    end


    @result = Hash.new
    @result['data'] = @data

    respond_to do |format|
      if params[:callback]
        format.json { render json: @result.to_json, callback: params[:callback] }
      else
        format.json { render  json: @result.to_json}
      end
    end
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
        @data = AdaData.with_game(game_name).where(:timestamp.gt => since).in(key: keys).asc(:timestamp)
      else
        @data = AdaData.with_game(game_name).where(game_id: params[:game_id]).where(:timestamp.gt => since).in(key: keys).asc(:timestamp)
      end
    end


    @result = Hash.new
    @result['data'] = @data
    respond_with @result

  end

  def key_counts

    client = get_client_by_token(params[:app_token])

    if client != nil

      since = time_range_to_epoch(params[:time_range])
      game_name = client.implementation.game.name

      keys = AdaData.with_game(game_name).where(:timestamp.gt => since).distinct(:key)


      @data_group = DataGroup.new
      keys.each_with_index do |k, index|

        count = AdaData.with_game(game_name).where(:timestamp.gt => since).where(key: k).count
        hash = Hash.new
        hash[k] = count
        @data_group.add_to_group(hash, nil, index, 'bar', k)
      end

      @chart_info = @data_group.to_rickshaw
      respond_to do |format|
          format.json {

            if params[:rickshaw] != nil
              render :json => @chart_info.to_json
            else
              render :json => @data_group.to_json
            end

          }
          format.html {render}
          format.csv { send_data @data_group.to_csv, filename: client.implementation.game.name+"_"+current_user.player_name+".csv" }
      end

    end


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
      @title = @graph_params.key
      @graph_params.field_names.each do |name|
          @title = @title + " : " + name
      end
      @title = @title  + " over time"
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

          var num = this;

          field_names.forEach(function(value){
              num = num[value];
          });

          data[this.timestamp] = num;
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
      scope = {since: since.to_i, field_names: JSON.parse(params[:field_names])}

      type_of_graph = 'line'

      player_info_map = Hash.new

      unless params[:game_id].nil? or params[:game_id].empty?
        first_time = AdaData.with_game(@game_name).order_by(:timestamp.asc).where(game_id: params[:game_id]).first.timestamp

        game_info = AdaData.with_game(@game_name).where(game_id: params[:game_id]).any_of(:ada_base_types.in => ['ADAGEGameInformation']).last
        if game_info != nil
          game_info.players.each do |key, value|
            user_id = key
            color = value['color']
            player_info_map[user_id] = Hash.new
            player_info_map[user_id]['identifier'] = value['identifier']
            player_info_map[user_id]['color'] = "rgba("+(color['r'].to_f*255).to_i.to_s+","+(color['g'].to_f*255).to_i.to_s+","+(color['b'].to_f*255).to_i.to_s+",1.0)"
            Rails.logger.debug player_info_map[user_id]['color']
          end

        end

        logs = AdaData.with_game(@game_name).order_by(:timestamp.asc).where(game_id: params[:game_id]).where(key: params[:key]).where(:timestamp.gt => first_time ).map_reduce(map,reduce).out(inline:1).scope(scope)
      else
        type_of_graph = 'bar'
        logs = AdaData.with_game(@game_name).order_by(:timestamp.asc).where(key: params[:key]).where(:timestamp.gt => since.to_s).map_reduce(map,reduce).out(inline:1).scope(scope)
      end


      @data_group = DataGroup.new
      logs.each do |l|
        @user = User.find(l["_id"].to_i)
        if l["value"] != nil
          color = nil
          name = nil
          player_info = player_info_map[@user.id.to_s]
          if player_info != nil
            color = player_info['color']
            name = player_info['identifier']
          end
          @data_group.add_to_group(l["value"], @user, @user.id, type_of_graph, name, color)
        end
      end

      @chart_info = @data_group.to_rickshaw
      respond_to do |format|
        format.json {

          if params[:rickshaw] != nil
            render :json => @chart_info.to_json
          else
            render :json => @data_group.to_json
          end

        }
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
       @data_group.add_to_group(session_time[u.id], u, u.id, 'bar')
    end

    @playtimes = @data_group.to_chart_js
    @rickshaw = @data_group.to_rickshaw
    respond_to do |format|
      format.json {

          if params[:rickshaw] != nil
            render :json => @data_group.to_rickshaw.to_json
          else
            render :json => @data_group.to_json
          end

        }

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
          @data_group.add_to_group(session_time,  @users[index], @users[index].id)
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
        @data_group.add_to_group(session_time,  @users[index], @users[index].id)
      end

      @average_time = total_session_length/sessions_played
      @session_count = sessions_played
      @total_time = total_session_length
    end
    @playtimes = @data_group.to_chart_js
    @rickshaw = @data_group.to_rickshaw
    respond_to do |format|
      format.json {

          if params[:rickshaw] != nil
            render :json => @data_group.to_rickshaw.to_json
          else
            render :json => @data_group.to_json
          end

        }
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
        @data_group.add_to_group(log["value"],  @users[index], @users[index].id)
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
        type = "text/csv"

        filename = @game.name+'_'+ params[:version]+'.csv'
        set_file_headers(filename,type)
        set_streaming_headers
        response.status = 200

        @user_ids = @user_ids.distinct(:user_id)
        self.response_body = Enumerator.new do |y|
          i=0
          @user_ids.each do |id|
            user = User.where(id: id).first
            unless user.nil?
              user.data_to_csv(@game.name, params[:version])
            end
            i+=1
            GC.start if i%500==0
          end
        end
      }
      format.json {
        data = AdaData.with_game(params[:gameName]).where(schema: params[:version]).in(user_id: params[:user_ids] )
        render :json => data
      }
    end
  end

  def set_file_headers(filename,type)
    headers["Content-Type"] = type
    headers["Content-disposition"] = "attachment; filename='#{filename}'"
  end

  def set_streaming_headers
    headers['X-Accel-Buffering'] = 'no'
    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
    headers['Last-Modified'] = Time.now.ctime.to_s
  end

  def attributes(gameName,schema="")
    keys = Hash.new
    data = nil
    if schema.present?
      data =  AdaData.with_game(@game.name).where(schema: schema).limit(3000)
    else
      data = AdaData.with_game(@game.name).limit(3000)
    end

    types = data.distinct(:key)
    examples = Array.new
    types.each do |type|
      ex = data.select{ |d| d.key.include?(type)}.last
      if ex != nil
        examples << ex
      end
    end
    all_attrs = Array.new
    examples.each do |e|
      e.attributes.keys.each do |k|
        unless all_attrs.include? k
          all_attrs << k
        end
      end
    end  

    return all_attrs
  end

  def export
    @game = Game.where('lower(name) = ?', params[:gameName].downcase).first
    authorize! :read, @game
    @user_ids = params[:user_ids]

    if params[:start]
      params[:start] = (Time.at((params[:start].to_i)/1000+86400).to_time.to_i*1000).to_i
    end
    if params[:end]
      params[:end] = (Time.at((params[:end].to_i)/1000+86400).to_time.to_i*1000).to_i
    end

    respond_to do |format|
      format.csv {

        #Pre Query all the data attributes
        all_attrs = attributes(@game.name)

        filename = @game.name+'.csv'

        unless  @user_ids.nil?
          data = AdaData.with_game(@game.name).in(user_id: @user_ids)
        else
          data = AdaData.with_game(@game.name)
        end

        if params[:end] and params[:start]
          start_date =  Time.at(params[:start].to_i/1000).to_time.strftime("%-m_%-d_%Y")
          end_date=  Time.at(params[:end].to_i/1000).to_time.strftime("%-m_%-d_%Y")
          filename = @game.name+"_"+start_date+"-"+end_date+'.csv'

          data = data.where(:timestamp.gte=> params[:start]).where(:timestamp.lte=> params[:end])
        elsif params[:start]
          data = data.where(:timestamp.gte=> params[:start])
        elsif params[:end]
          data = data.where(:timestamp.lte=> params[:end])
        end

        type = "text/csv"

        set_file_headers(filename,type)
        set_streaming_headers
        response.status = 200

        self.response_body = Enumerator.new do |y|
          y << CSV.generate_line(["player", "epoch time"] + all_attrs)
          user_id = -1
          player_name = ""
        
          i=0
          data.each do |entry|
            if user_id != entry.user_id
              user_id = entry.user_id
              user = User.find(user_id)
              player_name = user.player_name
            end

            out = Array.new
            out << player_name
            if entry.respond_to?('timestamp')
              if entry.timestamp.to_s.include?(':')
                out << DateTime.strptime(entry.timestamp.to_s, "%m/%d/%Y %H:%M:%S").to_time.to_i
              else
                out << entry.timestamp
              end
            else
              out << 'no timestamp'
            end

            all_attrs.each do |attr|
              if entry.attributes.keys.include?(attr)
                out << entry.attributes[attr]
              else
                out << ""
              end
            end
            y << CSV.generate_line(out)
            i+=1
            GC.start if i%5000==0
          end 
        end
      }
      format.json {
        unless  @user_ids.nil?
          data = AdaData.with_game(@game.name).in(user_id: @user_ids)
        else
          data = AdaData.with_game(@game.name)
        end

        if params[:start]
          data = data.where(:timestamp.gte=> params[:start])
        end

        if params[:end]
          data = data.where(:timestamp.lte=>params[:end])
        end

        filename = @game.name+'.json'

        if params[:end] and params[:start]
          start_date =  Time.at(params[:start].to_i/1000).to_time.strftime("%-m_%-d_%Y")
          end_date=  Time.at(params[:end].to_i/1000).to_time.strftime("%-m_%-d_%Y")
          filename = @game.name+"_"+start_date+"-"+end_date+'.json'
        end

        type = "text/json"

        set_file_headers(filename,type)
        set_streaming_headers
        response.status = 200

        self.response_body = Enumerator.new do |y|
          i=0
          data.all.each do |log|
            y << log.to_json + "\n"
            i+=1
            GC.start if i%5000==0
          end
        end
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