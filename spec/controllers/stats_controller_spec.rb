require 'spec_helper'

describe StatsController do
  let!(:teacher_role) { Role.create(name: 'teacher') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:researcher_role) { Role.create(name: 'researcher') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'teacher').first] }
  let!(:game) { Fabricate :game}
  let!(:app_token) {game.implementations.first.client.app_token}

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in :user, user
  end

  describe "#save_stat" do
    it "stat can be saved" do
      post :save_stat, format: :json, user_id: user.id, app_token: app_token, key: "test_key",value:"3142567382127"
      response.should be_success
    end

    it "returns an error for incorrect app token" do
      post :save_stat, format: :json, user_id: user.id, app_token: "asjdasodasd", key: "test_key",value:"3142567382127"

      data = JSON.parse(response.body)
      data["errors"].should be_any{ |m| m =~ /No Game found/}
    end

    it "returns an error for incorrect user" do
      post :save_stat, format: :json, user_id: 1232232, app_token: app_token, key: "test_key",value:"3142567382127"

      data = JSON.parse(response.body)
      data["errors"].should be_any{ |m| m =~ /Invalid User/}
    end
  end

  describe "#get_stat" do
    before(:each) do
      post :save_stat, format: :json, user_id: user.id, app_token: app_token, key: "test_key",value:"3142567382127"
    end

    it "stat can be saved" do
      get :get_stat, format: :json, user_id: user.id, app_token: app_token, key: "test_key"

      data = JSON.parse(response.body)
      data["data"].should =~ /3142567382127/
    end

    it "error returned for invalid key" do
      get :get_stat, format: :json, user_id: user.id, app_token: app_token, key: "tesasdasdast_key"

      data = JSON.parse(response.body)
      data["errors"].should be_any{ |m| m.to_s =~ /Stat Does Not Exist/}
    end

    it "error returned for app token" do
      get :get_stat, format: :json, user_id: user.id, app_token: "ASDASDAS", key: "test_key"

      data = JSON.parse(response.body)
      data["errors"].should be_any{ |m| m.to_s =~ /Game Not found for app token/}
    end
  end
end
