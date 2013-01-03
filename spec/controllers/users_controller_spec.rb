require 'spec_helper'

describe UsersController do

  describe "unity login" do
    let!(:player_role) { Role.create(name: 'player') }
    let!(:admin_role) { Role.create(name: 'admin') }
    let!(:user) { Fabricate :user, player_name: 'TestPlayer', password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }

    it "returns json containing authentication token" do
      post :authenticate_for_token, {'email' => user.email, 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      response.body.should match 'auth_token'
    end

    it "logs in without case sensitivity" do
      post :authenticate_for_token, {'email' => user.email.upcase, 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      response.body.should match 'auth_token'
    end

    it "logs in with player_name" do
      post :authenticate_for_token, {'email' => user.player_name, 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      response.body.should match 'auth_token'
    end

    it "player_name is also not case sensitive" do
      post :authenticate_for_token, {'email' => user.player_name.upcase, 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      response.body.should match 'auth_token'
    end

  end

  describe 'Retrieve data for a game' do
    let!(:player_role) { Role.create(name: 'player') }
    let!(:admin_role) { Role.create(name: 'admin') }
    let!(:game) {Fabricate :game}
    let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }
    let!(:data) {Fabricate :AdaData, gameName: game.name, user_id: user.id }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in :user, user
    end

        
    it 'if you are a reseraecher it returns the data for the game as a csv' do
      
      user.roles << Role.where(name: game.name).first
      user.save
      post :data_by_game, {'format' => 'csv', 'id' => user.id, 'gameName' => game.name}
    end
  end

end
