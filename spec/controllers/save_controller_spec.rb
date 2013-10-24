require 'spec_helper'

describe SaveController do
  let!(:player_role) { Role.create(name: 'player') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }
  let!(:game) { Fabricate :game }
  let!(:access_token) {Fabricate :access_token, user: user, client: game.implementations.first.client}
  let!(:app_token) {game.implementations.first.client.app_token}


  describe "save game" do
        
    it "creates a save record from incoming json" do
      lambda do
        @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
        post :save, 'game_save' => {"somestuff" => [{"one" => 1}, {"two" => 2}]}, 'app_token' => app_token 
        response.status.should be(201)
      end.should change(SaveData, :count).by(1)
      user.reload
      user.saves.count.should == 1
    end
    
    it "updates a save record from incoming json if the record exists" do
      lambda do
        @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
        post :save, 'game_save' => {"somestuff" => [{"one" => 1}, {"two" => 2}]}, 'app_token' => app_token 
        response.status.should be(201)
      end.should change(SaveData, :count).by(1)
      lambda do
        @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
        post :save, 'game_save' => {"somestuff" => [{"foo" => 1}, {"bar" => 2}]}, 'app_token' => app_token 
        response.status.should be(201)
      end.should_not change(SaveData, :count)
      user.saves.count.should == 1
      a_save = user.saves.where(implementation_id: game.implementations.first.id).first
      a_save.game_save['somestuff'][0]['foo'].should == "1"
    end

    
  end


  describe "load game" do
    
    it "returns a saved record as json" do 
      
      some_json =  {"somestuff" => [{"one" => 1}, {"two" => 2}]}.to_json
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :save, 'game_save' => some_json, 'app_token' => app_token 
      response.status.should be(201)
 
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      get :load, 'app_token' => app_token, :format => :json  
      response.status.should be(200)
      response.body.should have_content(some_json)
    end

    it "returns nothing if no saved game" do
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
