require 'spec_helper'

describe GvController do
  let!(:player_role) { Role.create(name: 'player') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }
  let!(:game) { Fabricate :game }
  let!(:access_token) {Fabricate :access_token, user: user, client: game.implementations.first.client}
  let!(:app_token) {game.implementations.first.client.app_token}


   describe "delete" do
    
    it "deletes the version data for the game" do  
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :delete, 'app_token' => app_token
      response.status.should be(201)
    end

  end


  describe "save stuff" do
        
    it "creates game version data from incoming json" do
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :delete, 'app_token' => app_token
      response.status.should be(201)

      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :save, 'game_version_data' => {'eventTypes' => ["somestuff" => [{"one" => 1}, {"two" => 2}]]}, 'app_token' => app_token,  :format => :json   
      response.status.should be(201)
    end
    
    it "issues a warning if the record exists" do
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :delete, 'app_token' => app_token
      response.status.should be(201)


      lambda do
        @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
        post :save, 'game_version_data' => {'eventTypes' => ["somestuff" => [{"one" => 1}, {"two" => 2}]]}, 'app_token' => app_token,  :format => :json   
        response.status.should be(201)
      end.should change(GameVersionData, :count).by(1)
      lambda do
        @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
        post :save, 'game_version_data' => {'eventTypes' => ["somestuff" => [{"one" => 1}, {"two" => 2}]]}, 'app_token' => app_token,  :format => :json  
        response.status.should be(401)
      end.should_not change(GameVersionData, :count)

    end

    
  end

  describe "show" do
    it "returns something reasonable" do
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :show, 'app_token' => app_token
      response.status.should be(200)
    end
  
  end


end
