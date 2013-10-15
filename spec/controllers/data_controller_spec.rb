require 'spec_helper'

describe DataController do
  let!(:player_role) { Role.create(name: 'player') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }
  let!(:client) { Fabricate :client }
  let!(:access_token) {Fabricate :access_token, user: user, client: client}

  describe "#index" do
        let(:datum) { create :datum }
    it "returns a list of data" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in :user, user
      get :index
      response.should be_success
    end
  end

  describe "data collector" do

    it "creates mongo records from incoming json using single token auth" do
      lambda do
        post :create, "data" => [{"one" => 1}, {"two" => 2}], "auth_token" => user.authentication_token
        response.status.should be(201)
      end.should change(AdaData, :count).by(2)
      assigns(:data).first.reload.user.should == user
    end
    
    it "creates mongo records from incoming json using header oauth authorization" do
      lambda do
        @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
        post :create, {"data" => [{"one" => 1}, {"two" => 2}]}
        response.status.should be(201)
      end.should change(AdaData, :count).by(2)
      assigns(:data).first.reload.user.should == user
    end
    
    it "creates mongo records from incoming json using param oauth authorization" do
      lambda do
        post :create, "data" => [{"one" => 1}, {"two" => 2}], 'authorization_token' => user.access_tokens.first.consumer_secret
        response.status.should be(201)
      end.should change(AdaData, :count).by(2)
      assigns(:data).first.reload.user.should == user
    end

    it "does not allow posting data without authorization" do
      lambda do
        post :create, "data" => [{"one" => 1}, {"two" => 2}]
        response.status.should_not be(201)
      end.should_not change(AdaData, :count).by(2)
    end

  end

end
