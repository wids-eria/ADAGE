class AccessToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :client

  def redirect_uri_for(redirect_uri)
    if redirect_uri =~ /\?/
      redirect_uri + "&code=#{consumer_token}&response_type=code"
    else
      redirect_uri + "?code=#{consumer_token}&response_type=code"
    end
  end
end
