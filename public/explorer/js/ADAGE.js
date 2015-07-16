function ADAGE(options){
  var self = this;

  self.login = function(email,password,callback){
    $.post(self.adageurl+"/auth/authorize_unity",{email: email,password: password,client_id:self.app_token,client_secret: self.app_secret}, function( data ){
      self.access_token = data['access_token'];
      window.localStorage.setItem("access_token",self.access_token);
    }).always(function(data){
      callback(data);
    });
  };

  self.logout = function(){
    self.access_token = undefined;
    window.localStorage.removeItem("access_token");
  }

  self.signed_in = function(){
    if(self.access_token  == undefined && window.localStorage.getItem("access_token") == undefined){
      return false;
    }else{
      self.access_token = window.localStorage.getItem("access_token");
    }
    return true;
  }()
  
  self.query = function(callback,context){
    $.ajax({
      url: self.adageurl+"/data/context_frequency.json",
      type: 'GET',
      dataType: "jsonp",
      beforeSend: function (xhr) {
        xhr.setRequestHeader('Authorization', 'bearer '+self.access_token);
      },
      timeout: 3000,
      data: {
        app_token: self.app_token,
        auth_token: self.access_token,
        filters: App.filters(), 
      },
      success: function (data) {
        callback(data.data);
      }
    }).fail(function(jqXHR, textStatus) {
      console.log(jqXHR);
    });
  };

  self.context_list = function(key,callback,context){

    $.ajax({
      url: self.adageurl+"/data/context_list.json",
      type: 'GET',
      dataType: "jsonp",
      beforeSend: function (xhr) {
        xhr.setRequestHeader('Authorization', 'bearer '+self.access_token);
      },
      timeout: 3000,
      data: {
        app_token: self.app_token,
        auth_token: self.access_token,
        filters: App.filters(), 
        key: key
      },
      success: function (data) {
        callback(data.data);
      }
    }).fail(function(jqXHR, textStatus) {
      console.log(jqXHR);
    });
  };

  self.context_list_by_name = function(key,name,callback,context){

    $.ajax({
      url: self.adageurl+"/data/context_list_keyed.json",
      type: 'GET',
      dataType: "jsonp",
      beforeSend: function (xhr) {
        xhr.setRequestHeader('Authorization', 'bearer '+self.access_token);
      },
      timeout: 3000,
      data: {
        app_token: self.app_token,
        auth_token: self.access_token,
        filters: App.filters(), 
        key: key, 
        name: name
      },
      success: function (data) {
        callback(data.data);
      }
    }).fail(function(jqXHR, textStatus) {
      console.log(jqXHR);
    });
  };

  self.context_event_type_list = function(client_id,key,name,callback,context){

    $.ajax({
      url: self.adageurl+"/data/context_event_type_list.json",
      type: 'GET',
      dataType: "jsonp",
      beforeSend: function (xhr) {
        xhr.setRequestHeader('Authorization', 'bearer '+self.access_token);
      },
      timeout: 3000,
      data: {
        app_token: self.app_token,
        auth_token: self.access_token,
        filters: App.filters(), 
        client_id: client_id,
        key: key, 
        name: name
      },
      success: function (data) {
        callback(data.data);
      }
    }).fail(function(jqXHR, textStatus) {
      console.log(jqXHR);
    });
  };

  self.context_event_count = function(client_id,event_key,callback,context){

    $.ajax({
      url: self.adageurl+"/data/context_event_count.json",
      type: 'GET',
      dataType: "jsonp",
      beforeSend: function (xhr) {
        xhr.setRequestHeader('Authorization', 'bearer '+self.access_token);
      },
      timeout: 3000,
      data: {
        app_token: self.app_token,
        auth_token: self.access_token,
        filters: App.filters(), 
        client_id: client_id,
        event_key: event_key, 
      },
      success: function (data) {
        callback(data.data);
      }
    }).fail(function(jqXHR, textStatus) {
      console.log(jqXHR);
    });
  };

  self.export = function(params,callback,context){
    var key = params[0];
    var name = params[1];
    var client_id = params[2];
    var event_key = params[3];
    var data = {
      app_token: self.app_token,
      auth_token: self.access_token,
      filters: App.filters(), 
      key: key,
      name: name, 
      client_id: client_id,
      event_key: event_key, 
    }
  
    var url = self.adageurl+"/data/visualizer_export.json?"+$.param(data);
    window.location = url;
  }

  function ADAGE(){
    self.adageurl = options.url;
    self.app_token = options.app_token;
    self.app_secret = options.app_secret;
  };

  return ADAGE();
};