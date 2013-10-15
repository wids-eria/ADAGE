require 'spec_helper'

describe OauthController do

  describe "guest accounts" do
    let (:json)  { JSON.parse(response.body) }
    let (:client_app) {Client.create(name: 'TestApp', app_token: 'foo', app_secret: '12345')}

    it "creates guest accounts!" do 
      post :guest, {'client_id' => client_app.app_token, 'client_secret' => client_app.app_secret, 'format' => 'json'}
      response.should be_success
      puts response.body
      puts json["info"]["player_name"]
      json["info"]["guest"].should == true
    end

  end

end
