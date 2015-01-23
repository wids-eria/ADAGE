require 'spec_helper'

describe UsersController do

  describe "unity login" do
    let!(:player_role) { Role.create(name: 'player') }
    let!(:admin_role)  { Role.create(name: 'admin')  }
    let!(:researcher_role) { Role.create(name: 'researcher') }
    let (:roles) { [Role.where(name: 'admin').first, Role.where(name: 'player').first] }
    let!(:group) { Fabricate :group ,name: "Play Squad"}
    let!(:user)  { Fabricate :user, player_name: 'TestPlayer', email: 'Test@email.com', authentication_token: 'abcdefg', password: 'pass1234', roles: roles }
    let (:json)  { JSON.parse(response.body) }
    let!(:game) { Fabricate :game}
    let!(:app_token) {game.implementations.first.client.app_token}
    let!(:access_token) {Fabricate :access_token, user: user, client: game.implementations.first.client}

    it "returns json containing authentication token" do
      post :authenticate_for_token, {'email' => 'Test@email.com', 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      json["auth_token"].should == "abcdefg"
    end


    it "logs in with case insensitive email" do
      post :authenticate_for_token, {'email' => 'TeSt@email.com', 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      json["auth_token"].should == "abcdefg"
    end


    it "logs in with player_name" do
      post :authenticate_for_token, {'email' => 'TestPlayer', 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      json["auth_token"].should == "abcdefg"
    end


    it "logs in with case insensitive player_name" do
      post :authenticate_for_token, {'email' => 'testPLAYER', 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      json["auth_token"].should == "abcdefg"
    end

    it "gets list of groups player is in" do
      get :groups, format: :json, id: user.id
      puts response.body.to_yaml
      data = JSON.parse(response.body)
      response.should be_success
    end

    it "errors is there is an invalid app token for groups player" do


    end
  end
end
