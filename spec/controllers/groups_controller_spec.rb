require 'spec_helper'

describe GroupsController do
  let!(:teacher_role) { Role.create(name: 'teacher') }
  let!(:admin_role) { Role.create(name: 'admin') }
  let!(:user) { Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'teacher').first] }


  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in :user, user
  end

  describe "#index" do
    let(:group) { Fabricate :groups }
    it "returns a list of groups" do
      get :index
      response.should be_success
    end
  end
=begin
  describe "#show" do
    let(:group) { Fabricate :group }
    it "returns group and a list of users" do
      puts group.inspect
      get :show, :id => group.id
      response.should be_success
    end
  end
=end
end