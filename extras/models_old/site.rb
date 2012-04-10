class Site < ActiveRecord::Base
  validates_presence_of   :fqdn
  validates_uniqueness_of :fqdn
  validates_format_of     :fqdn, :with => /^[a-z0-9\-\.]+$/i

  has_many :locators
  has_many :tips, :through => :locators

  attr_accessible :fqdn
end
