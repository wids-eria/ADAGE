require 'spec_helper'

describe GroupsController do
  let!(:teacher_role) { Role.create(name: 'teacher') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:researcher_role) { Role.create(name: 'researcher') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'teacher').first] }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in :user, user
  end

  describe "#index" do
    it "returns a list of groups" do
      get :index
      response.should be_success
    end
  end

  describe "#show" do
    let(:group) { Fabricate :group ,name: "Play Squad"}
    it "returns group and a list of users" do
      get :show, :id => group.id
      response.should be_success
    end
  end
end