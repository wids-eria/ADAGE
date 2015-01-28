require 'spec_helper'

describe AchievementsController do
  let!(:teacher_role) { Role.create(name: 'teacher') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:researcher_role) { Role.create(name: 'researcher') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'teacher').first] }
  let!(:game) { Fabricate :game}
  let!(:app_token) {game.implementations.first.client.app_token}
  let!(:access_token) {Fabricate :access_token, user: user, client: game.implementations.first.client}

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in :user, user
  end

  describe "#save_achievement" do
    it "achievement can be saved" do
      post :save_achievement, format: :json, access_token: access_token.consumer_secret, key: "test_key",value:"3142567382127"
      response.should be_success
    end

    it "returns an error for invalid access_token" do
      post :save_achievement, format: :json, access_token: "ASDASDASDASDASD", key: "test_key",value:"3142567382127"

      data = JSON.parse(response.body)
      data["errors"].should be_any{ |m| m.to_s =~ /Invalid Access/}
    end
  end

  describe "#get_achievement" do
    before(:each) do
      post :save_achievement, format: :json, access_token: access_token.consumer_secret, key: "test_key",value:true
    end

    it "achievement can be retrieved" do
      get :get_achievement, format: :json, access_token: access_token.consumer_secret,  key: "test_key"

      data = JSON.parse(response.body)
      data["data"].should =~ /true/
    end

    it "error returned for invalid key" do
      get :get_achievement, format: :json, access_token: access_token.consumer_secret, key: "tesasdasdast_key"

      data = JSON.parse(response.body)
      data["errors"].should be_any{ |m| m.to_s =~ /Achievement Does Not Exist/}
    end

    it "error returned for invalid access token" do
      get :get_achievement, format: :json, access_token: "ASDASDASD",  key: "test_key"

      data = JSON.parse(response.body)
      data["errors"].should be_any{ |m| m.to_s =~ /Invalid Access/}
    end
  end


  describe "#get_achievements" do
    before(:each) do
      post :save_achievement, format: :json, access_token: access_token.consumer_secret, key: "first_key",value:true
      post :save_achievement, format: :json, access_token: access_token.consumer_secret, key: "second_key",value:false
    end

    it "achievement can be retrieved" do
      get :get_achievements, format: :json, access_token: access_token.consumer_secret,  key: "test_key"

      data = JSON.parse(response.body)
      puts data

      response.should be_success
    end


    it "error returned for invalid access token" do
      get :get_achievements, format: :json, access_token: "ASDASDASD"

      data = JSON.parse(response.body)
      data["errors"].should be_any{ |m| m.to_s =~ /Invalid Access/}
    end
  end
end
