class Client < ActiveRecord::Base
  before_create :generate_tokens

  def generate_tokens
    self.app_token = SecureRandom.hex(16)
    self.app_secret = SecureRandom.hex(32)
  end

end
