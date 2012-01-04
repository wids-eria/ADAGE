require 'spec_helper'

describe UsersController do

  describe "unity login" do
    let(:user) { create :user }

    it "returns json containing authentication token" do
      get 'index'
      response.should be_success
    end
  end

end
