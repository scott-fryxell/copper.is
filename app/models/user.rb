# == Schema Information
# Schema version: 20100324194135
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)
#  crypted_password   :string(255)
#  password_salt      :string(255)
#  persistence_token  :string(255)
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class User < ActiveRecord::Base
  acts_as_authentic
  has_one :address
  has_many :accounts
  has_many :orders, :through => :accounts
  has_many :tips
  has_many :resources
  has_and_belongs_to_many :roles

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  attr_accessible :email, :password, :password_confirmation
end
