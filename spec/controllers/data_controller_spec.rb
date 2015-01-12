require 'spec_helper'

describe DataController do
  let!(:player_role) { Role.create(name: 'player') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:researcher_role) { Role.create(name: 'researcher') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }
  let!(:game) { Fabricate :game }
  let!(:access_token) {Fabricate :access_token, user: user, client: game.implementations.first.client}

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
      old_count = user.data("Fake Game").count
      post :create, "data" => [{"gameName" => "Fake Game"}], "auth_token" => user.authentication_token
      response.status.should be(201)
      user.data("Fake Game").count.should be(old_count + 1)
    end

    it "creates mongo records from incoming json using header oauth authorization" do
      old_count = user.data("Fake Game").count
      @request.env['HTTP_AUTHORIZATION'] =  "Bearer " + user.access_tokens.first.consumer_secret
      post :create, {"data" => [{"gameName" => "Fake Game"}]}
      response.status.should be(201)
      user.data("Fake Game").count.should be(old_count + 1)
    end

    it "creates mongo records from incoming json using param oauth authorization" do
      old_count = user.data("Fake Game").count
      post :create, "data" => [{"gameName" => "Fake Game"}], 'authorization_token' => user.access_tokens.first.consumer_secret
      response.status.should be(201)
      user.data("Fake Game").count.should be(old_count + 1)
    end

    it "does not allow posting data without authorization" do
      old_count = AdaData.with_game("Fake Game").count
      post :create, {"data" => [{"gameName" => "Fake Game"}]}
      response.status.should_not be(201)
      AdaData.with_game("Fake Game").count.should be(old_count)
    end

  end

end
