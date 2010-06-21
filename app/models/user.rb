class User < ActiveRecord::Base
  acts_as_authentic

  has_one :address
  has_many :accounts
  has_many :orders, :through => :accounts
  has_many :tips
  has_many :resources
  has_and_belongs_to_many :roles

  #AuthLogic validate the uniqueness of the email field by convention
  #validates_uniqueness_of :email

  attr_accessible :email, :password, :password_confirmation

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
end
