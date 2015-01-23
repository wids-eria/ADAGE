require 'spec_helper'

describe GroupsController do
  let!(:teacher_role) { Role.create(name: 'teacher') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:researcher_role) { Role.create(name: 'researcher') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'teacher').first] }
  let!(:group) { Fabricate :group ,name: "Play Squad"}
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
    it "returns group and a list of users" do
      get :show, :id => group.id
      response.should be_success
    end
  end

  describe "#add_user_to_group" do
    it "returns an error if user can be added to group" do
      put :add_user, format: :json, id: group.id, player_group: {
        user_ids: [user.id]
      }
      group.users.count.should eq(1)
    end
  end

  describe "#remove_user_from_group" do
    it "returns an error if user can't be removed from a group" do
      put :add_user, format: :json, id: group.id, player_group: {
        user_ids: [user.id]
      }
      delete :remove_user, format: :json, id: group.id, player_group: {
        user_ids: [user.id]
      }
      group.users.count.should eq(0)
    end
  end
end