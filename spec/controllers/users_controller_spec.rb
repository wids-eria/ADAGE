require 'spec_helper'

describe UsersController do

  describe "unity login" do
    let(:user) { Fabricate :user }

    it "returns json containing authentication token" do
      post data_collector_path
      response.should be_success
      response.should_contain "blah"
    end
  end

end
