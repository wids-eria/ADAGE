class UserSequence
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :start_value, :prefix, :count, :password

  validates :count,       presence: true, numericality: {only_integer: true, greater_than:  0}
  validates :start_value, presence: true, numericality: {only_integer: true, greater_than: -1}
  validates :prefix,      presence: true
  validates :password,    presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def create_users!
    @users = []
    (start_value.to_i...start_value.to_i+count.to_i).each do |n|
      email = "#{prefix}_#{n}@stu.de.nt"
      @users << User.new(email: email, password: password)
    end
    @users.each{|user| user.save!}
    @users
  end
end
