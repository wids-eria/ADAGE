require 'spec_helper'

describe OauthController do

  describe "guest accounts" do
    let (:json)  { JSON.parse(response.body) }
    let (:client_app) {Client.create(name: 'TestApp', app_token: 'foo', app_secret: '12345')}

    it "creates guest accounts!" do 
      post :guest, {'client_id' => client_app.app_token, 'client_secret' => client_app.app_secret, 'format' => 'json'}
      response.should be_success
      get :adage_user, {'authorization_token' => json['access_token'], 'format' => 'json'}
      response.should be_success
      json = JSON.parse(response.body) 
      puts json["player_name"]
      json["guest"].should == true
    end

  end

  describe "guest accounts for brainpop" do
    let (:json)  { JSON.parse(response.body) }
    let (:client_app) {Client.create(name: 'TestApp', app_token: 'foo', app_secret: '12345')}

    it "creates guest account for a brainpop user" do
      post :authorize_brainpop, {'client_id' => client_app.app_token, 'client_secret' => client_app.app_secret, 'player_id' => 'brainpopuser1','format' => 'json'}
      response.should be_success
      get :adage_user, {'authorization_token' => json['access_token'], 'format' => 'json'}
      response.should be_success
      json = JSON.parse(response.body) 
      puts json["player_name"]
      json["guest"].should == true
    end

  end

end
