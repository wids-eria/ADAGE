require 'spec_helper'

describe UsersController do

  describe "unity login" do
    let!(:player_role) { Role.create(name: 'player') }
    let!(:admin_role)  { Role.create(name: 'admin')  }
    let (:roles) { [Role.where(name: 'admin').first, Role.where(name: 'player').first] }
    let!(:user)  { Fabricate :user, player_name: 'TestPlayer', email: 'Test@email.com', authentication_token: 'abcdefg', password: 'pass1234', roles: roles }
    let (:json)  { JSON.parse(response.body) }


    it "returns json containing authentication token" do
      post :authenticate_for_token, {'email' => 'Test@email.com', 'password' => 'pass1234', 'format' => 'json'}
      puts '*'*10
      puts response
      puts '*'*10
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
  end
end
