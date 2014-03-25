require 'spec_helper'

describe ConfigController do
  let!(:player_role) { Role.create(name: 'player') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }
  let!(:game) { Fabricate :game }
  let!(:access_token) {Fabricate :access_token, user: user, client: game.implementations.first.client}
  let!(:app_token) {game.implementations.first.client.app_token}


  describe "save config" do
        
    it "creates a config record from incoming json" do
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :save, 'config_file' => {"somestuff" => [{"one" => 1}, {"two" => 2}]}, 'app_token' => app_token 
      response.status.should be(201)
      game.reload
      game.configs.count.should == 1
    end
    
    it "updates a config record from incoming json if the record exists" do
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :save, 'config_file' => {"somestuff" => [{"one" => 1}, {"two" => 2}]}, 'app_token' => app_token 
      response.status.should be(201)
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :save, 'config_file' => {"somestuff" => [{"foo" => 1}, {"bar" => 2}]}, 'app_token' => app_token 
      response.status.should be(201)
      game.configs.count.should == 1
      a_save = game.configs.where(implementation_id: game.implementations.first.id).first
      a_save.config_file['somestuff'][0]['foo'].should == "1"
    end

    
  end


  describe "load config" do
    
    it "returns a saved record as json" do 
      
      some_json =  {"somestuff" => [{"one" => 1}, {"two" => 2}]}.to_json
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :save, 'config_file' => some_json, 'app_token' => app_token 
      response.status.should be(201)
 
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      get :load, 'app_token' => app_token, :format => :json  
      response.status.should be(200)
      response.body.should have_content(some_json)
    end

    it "returns nothing if no saved config" do
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      get :load, 'app_token' => app_token, :format => :json  
      response.body.should have_content('') 
    end

    it "returns 401 when you don't have auth" do 
      get :load, 'app_token' => app_token, :format => :json  
      response.status.should be(401)
    end
  
  end

end
