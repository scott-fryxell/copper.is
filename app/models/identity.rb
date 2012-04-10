class Identity < ActiveRecord::Base
  belongs_to :user
  has_many :pages
  has_many :royalty_checks, :through => :pages

  attr_accessible :provider, :uid

  def self.find_with_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'].to_s)
  end

  def self.create_with_omniauth(auth)
    Identity.create(uid: auth['uid'].to_s, provider: auth['provider'])
  end

end
