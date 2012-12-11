require 'spec_helper'

describe UsersController do

  describe "unity login" do
    let!(:player_role) { Role.create(name: 'player') }
    let!(:admin_role) { Role.create(name: 'admin') }
    let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }

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
  end

  describe 'Retrieve data for a game' do
    let!(:player_role) { Role.create(name: 'player') }
    let!(:admin_role) { Role.create(name: 'admin') }
    let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }
    let!(:game) {Fabricate :game}
    let!(:data) {Fabricate :AdaData, gameName: game.name, user_id: user.id }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in :user, user
    end
    
    it 'returns the data for the game as a csv' do
      
      post :data_by_game, {'format' => 'csv', 'id' => user.id, 'gameName' => game.name}
      response.should be_success
      
    end
  end

end
