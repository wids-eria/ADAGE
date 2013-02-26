require 'spec_helper'

describe UsersController do

  describe "unity login" do
    let!(:player_role) { Role.create(name: 'player') }
    let!(:admin_role)  { Role.create(name: 'admin')  }
    let (:roles) { [Role.where(name: 'admin').first, Role.where(name: 'player').first] }
    let!(:user2) { Fabricate :user, player_name: 'testplayer', email: 'test@email.com', authentication_token: 'acdefge', password: 'pass1234', roles: roles }
    let!(:user)  { Fabricate :user, player_name: 'TestPlayer', email: 'Test@email.com', authentication_token: 'abcdefg', password: 'pass1234', roles: roles }
    let (:json)  { JSON.parse(response.body) }


    it "returns json containing authentication token" do
      post :authenticate_for_token, {'email' => 'Test@email.com', 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      json["auth_token"].should == "abcdefg"
    end


    it "logs in without case sensitivity" do
      post :authenticate_for_token, {'email' => 'TeSt@example.com', 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      json["auth_token"].should == "abcdefg"
    end


    it "logs in with player_name" do
      post :authenticate_for_token, {'email' => 'TestPlayer', 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      json["auth_token"].should == "abcdefg"
    end


    it "player_name is also not case sensitive" do
      post :authenticate_for_token, {'email' => user.player_name.upcase, 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      json["auth_token"].should == "abcdefg"
    end


    # BUGFIX
    it "logs in a user whos name is capitalized"
    it "logs in a user with player name bug"

  end

end
