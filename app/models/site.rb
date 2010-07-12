class Site < ActiveRecord::Base
  validates_presence_of   :fqdn
  validates_uniqueness_of :fqdn
  validates_format_of     :fqdn, :with => /^[a-z0-9\-\.]+$/i
end
