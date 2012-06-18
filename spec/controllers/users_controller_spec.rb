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

end
