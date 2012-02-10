require 'spec_helper'

describe DataController do
  let!(:user) { Fabricate :user, password: 'pass1234' }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in :user, user
  end

  describe "#index" do
    let(:datum) { create :datum }
    it "returns a list of data" do
      get :index
      response.should be_success
    end
  end

  describe "data collector" do

    it "creates mongo records from incoming json" do
      lambda do
        post :create, "data" => [{"one" => 1}, {"two" => 2}], "format" => "json"
        response.status.should be(201)
      end.should change(AdaData, :count).by(2)
      assigns(:data).first.reload.user.should == user
    end
  end
end
