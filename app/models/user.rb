class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_and_belongs_to_many :roles
  has_many :assignments
  has_many :roles, :through => :assignments

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def active_for_authentication?
    super && !self.blocked
  end

  def user_name
    email.split('@')[0]
  end
  
end
