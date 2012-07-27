class AccessToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
  before_create :generate_tokens

  def self.authenticate(consumer_token, application_id)
    AccessToken.where(consumer_token: consumer_token, client_id: application_id).first
  end

  def redirect_uri_for(redirect_uri)
    if redirect_uri =~ /\?/
      redirect_uri + "&code=#{consumer_token}&response_type=code"
    else
      redirect_uri + "?code=#{consumer_token}&response_type=code"
    end
  end

  def generate_tokens
    self.consumer_token = SecureRandom.hex(16)
    self.consumer_secret = SecureRandom.hex(16)
  end
end
