class User < ActiveRecord::Base
  has_paper_trail
  include Enqueueable
  
  has_one :fan
  has_one :author
  
  has_and_belongs_to_many :roles

  def self.create_with_omniauth(auth)
    create! do |user|
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.roles << Role.find_by_name('Patron')
    end
  end

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def patron?
    roles.find{|e| e.name == 'Patron'}
  end

  def charge_info?
    !!self.stripe_customer_id
  end

  def current_tips
    current_order.tips
  end

  def message_about_check(check_id)
    CheckMailer.check(Check.find(check_id)).deliver
  end
end
