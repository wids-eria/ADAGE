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

  describe "full account from the client" do 
    let (:json)  { JSON.parse(response.body) }
    let (:client_app) {Client.create(name: 'TestApp', app_token: 'foo', app_secret: '12345')}

    it "if the user doesn't exist it creates the account" do 
      post :client_side_create_user, {'client_id' => client_app.app_token, 'client_secret' => client_app.app_secret, 'player_name' => 'testman', 'email' => 'test@test.com', 'password' => 'foobar!', 'password_confirm' => 'foobar!'}
      json['access_token'].should_not be_nil
    end

    it "if they already exist it logs them in" do
      user = Fabricate :user, password: 'foobar!'
      post :client_side_create_user, {'client_id' => client_app.app_token, 'client_secret' => client_app.app_secret, 'player_name' => user.player_name, 'email' => user.email, 'password' => 'foobar!', 'password_confirm' => 'foobar!'}
      json['access_token'].should_not be_nil
    end

    it "returns errors if the info is not right" do
      post :client_side_create_user
      json['access_token'].should be_nil
    end
  
  
  end

end
