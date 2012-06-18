class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable

  before_save :ensure_authentication_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :authentication_token

  # for pathfinder, remove when sso is complete
  before_create :update_control_group

  has_and_belongs_to_many :roles

  def role?(role)
      return !!self.roles.find_by_name(role.to_s)
  end

  def data
    AdaData.where("user_id" => self.id)
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
end
