class Client < ActiveRecord::Base
  before_create :generate_tokens
  belongs_to :implementation 

  attr_accessible :implementation, :name, :app_token, :app_secret

  def generate_tokens
    self.app_token = implementation.name + '_' + SecureRandom.hex(16)
    self.app_secret = SecureRandom.hex(32)
  end

  def reset_secret
    self.app_secret = SecureRandom.hex(32)
  end

end
