require 'spec_helper'

describe UsersController do

  describe "unity login" do
    let!(:user) { Fabricate :user, password: 'pass1234' }

    it "returns json containing authentication token" do
      post :authenticate_for_token, {'email' => user.email, 'password' => 'pass1234', 'format' => 'json'}
      response.should be_success
      response.body.should match 'auth_token'
    end
  end

end
