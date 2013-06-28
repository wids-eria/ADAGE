require 'spec_helper'

describe GamesController do
  let!(:player_role) { Role.create(name: 'player') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first] }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in :user, user
  end

  describe "#index" do
    let(:game) { Fabricate :game }
    it "returns a list of games" do
      get :index
      response.should be_success
    end
  end

  describe "#show" do
    let(:game) { Fabricate :game }
    it "returns a game and a list of users" do 
      puts game.inspect
      get :show, :id => game.id
      response.should be_success
    end
  end

end

