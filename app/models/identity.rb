class Identity < ActiveRecord::Base
  belongs_to :user

  attr_accessible :provider, :uid

  def self.find_with_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'])
  end

  def self.create_with_omniauth(auth)
    Identity.create(uid: auth['uid'], provider: auth['provider'])
  end

end
