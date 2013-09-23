class SocialAccessToken < ActiveRecord::Base
  belongs_to :user
  attr_accessible :access_token, :expired_at, :provider, :uid, :user
  validates :access_token, presence: true
  validates :uid, presence: true
  validates :provider, presence: true
  validates :user, presence: true

  def update access_token, expired_at
    self.access_token = access_token
    self.expired_at = expired_at
    self.save
  end

  def expired?
    self.expired_at > Time.now
  end


end
