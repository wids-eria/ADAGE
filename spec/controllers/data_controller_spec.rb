require 'spec_helper'

describe DataController do

  describe "data collector" do
    let!(:user) { Fabricate :user, password: 'pass1234' }

    it "creates mongo records from incoming json" do
      lambda do
        post :create, "data" => [{"one" => 1}, {"two" => 2}] 
        response.should be_success
      end.should change(AdaData, :count).by(2)
    end
  end

end
