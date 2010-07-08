class User < ActiveRecord::Base
  acts_as_authentic

  has_one :address
  has_many :accounts
  has_many :orders, :through => :accounts
  has_many :tips

  has_many :transactions, :through => :accounts
  has_and_belongs_to_many :roles

  #AuthLogic validate the uniqueness of the email field by convention
  #validates_uniqueness_of :email

  attr_accessible :email, :password, :password_confirmation

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def activate!
    self.active = true
    self.activation_date = Time.now
    save
  end

  def deliver_user_activation!
    reset_perishable_token!
    Notifier.deliver_user_activation(self)
  end

  def deliver_user_welcome!
    reset_perishable_token!
    Notifier.deliver_user_welcome(self)
  end

  def deliver_password_reset!
    reset_perishable_token!
    Notifier.deliver_password_reset(self)
  end

  def self.find_active_users
    find(:all, :conditions => "active = 't'", :order => "created_at DESC")
  end

end
