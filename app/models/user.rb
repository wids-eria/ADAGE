class User < ActiveRecord::Base
  include Pacecar
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable,
         :token_authenticatable, :authentication_keys => [:login]

  before_save :ensure_authentication_token

  attr_accessor :login
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :player_name, :password, :password_confirmation, :remember_me, :authentication_token, :role_ids, :consented, :guest

  # for pathfinder, remove when sso is complete
  before_create :update_control_group
  before_save :set_default_role

  before_validation :email_or_player_name, :on => :create
  validates :player_name, presence: true, uniqueness: {case_sensitive: false}

  has_many :assignments
  has_and_belongs_to_many :roles
  has_many :access_tokens
  has_many :social_access_tokens

  def role?(role)
      return !!self.roles.find_by_name(role.name)
  end

  def researcher_role?
    return !!self.roles.find_by_type('ResearcherRole')
  end

  def admin?
    return !!self.roles.find_by_name('admin')
  end

  def data
    AdaData.where("user_id" => self.id)
  end

  def progenitor_data
    AdaData.where("user_id" => self.id, "gameName" => "ProgenitorX")
  end


  def self.with_login(login)
    where(["lower(player_name) = :login OR lower(email) = :login", login: login.strip.downcase])
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).with_login(login).first
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(email: auth.info.email).first

    if user.blank?
      password =  Devise.friendly_token[0,20]
      user = User.create(player_name:auth.extra.raw_info.name,
                          email:auth.info.email,
                           password:password,
                           password_confirm:password
                        )
    end


    fb_access = user.social_access_tokens.where(provider: auth.provider)
    if fb_access.present?
      fb_access.update(auth.access_token, auth.expires_at)
    else
      fb_access = SocialAccessToken.create(
        user: user,
        provider: auth.provider,
        uid: auth.uid,
        access_token: auth.credentials.token,
        expired_at: auth.credentials.expires_at
      )
    end
    user
  end

  def self.create_guest
    #generate token since the playername and email have to be unique
    token = SecureRandom.hex(16)

    guest = User.create(
      player_name: "Guest_"+token,
      email: "Guest_"+token+"@guest.com",
      guest: true,
    )
    return guest
  end

  private

  #override devise password to allow guest acounts with nil passwords
  def password_required?
    super && !self.guest
  end

  #override devise password to allow guest acounts with nil emails
  def email_required?
    super && !self.guest
  end

  def update_control_group
    if self.control_group.nil?
      if rand() < 0.5
        self.control_group = false
      else
        self.control_group = true
      end
    end

    true
  end

  def set_default_role
    if self.new_record?
      default_role = Role.where(name: 'player').first || Role.create(name: 'player')
      if !self.roles.present?
        self.roles = [default_role]
      elsif !self.role?(default_role)
        self.roles << default_role
      end
    end
  end

  def email_or_player_name
    if self.email.blank? && self.player_name.present?
      self.email = self.player_name + "@stu.de.nt"
    elsif self.player_name.blank? && self.email.present? && self.email.match("@")
      self.player_name = self.email.split("@").first
    end
  end
end
