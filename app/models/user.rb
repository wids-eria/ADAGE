class User < ActiveRecord::Base
  include Pacecar
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :authentication_keys => [:login]

  before_save :ensure_authentication_token

  attr_accessor :login
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :player_name, :password, :password_confirmation, :remember_me, :authentication_token, :role_ids, :consented

  # for pathfinder, remove when sso is complete
  before_create :update_control_group
  before_save :set_default_role

  before_validation :email_or_player_name, :on => :create
  validates :player_name, presence: true, uniqueness: {case_sensitive: false}

  has_many :assignments
  has_and_belongs_to_many :roles
  has_many :access_tokens

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

  def data_to_csv(csv, gameName, schema='')
    keys = Hash.new
    data = self.data.where(gameName: gameName)
    if schema.present?
      data = data.where(schema: schema)
    end
    data = data.asc(:timestamp)
    types = data.distinct(:key)
    examples = Array.new
    types.each do |type|
      ex = data.where(key: type).first
      if ex != nil
        examples << ex
      end
    end
    all_attrs = Array.new
    examples.each do |e|
      e.attributes.keys.each do |k|
        all_attrs << k
      end
    end
    csv << ["player", "epoch time"] + all_attrs.uniq
    data.each do |entry|
      out = Array.new
      out << self.player_name
      if entry.timestamp.to_s.include?('/') 
        out << DateTime.strptime(entry.timestamp.to_s, "%m/%d/%Y %H:%M:%S").to_time.to_i
      else
        out << 'does not compute'
      end
      all_attrs.uniq.each do |attr|
        if entry.attributes.keys.include?(attr)
          out << entry.attributes[attr]
        else
          out << ""
        end
      end
      csv << out
    end
    return csv
  end
  


  private

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
