class Locator < ActiveRecord::Base
  belongs_to :page
  belongs_to :site

  has_many :tips

  validates_presence_of :page
  validates_presence_of :site
  validates_presence_of :scheme

  def host
    site.fqdn
  end

  def host=(hostname_string)
    self.site = Site.find_or_create_by_fqdn(hostname_string)
  end

  def canonicalized
    canonical = scheme + '://'
    canonical << userinfo + '@' if userinfo
    canonical << site.fqdn
    canonical << canonical_port
    canonical << (path ? path : '/')
    canonical << '?' + query if query
    canonical << '#' + fragment if fragment

    canonical
  end

  def self.parse(url_string)
    raw_uri = URI.parse(url_string)

    adapted = Locator.new
    adapted.scheme   = raw_uri.scheme
    adapted.site     = Site.find_or_create_by_fqdn(raw_uri.host)
    adapted.userinfo = raw_uri.userinfo if (raw_uri.userinfo != nil && raw_uri.userinfo != '')
    adapted.port     = raw_uri.port     if (raw_uri.port != nil && raw_uri.port != '')
    adapted.path     = raw_uri.path     if (raw_uri.path != nil && raw_uri.path != '')
    adapted.query    = raw_uri.query    if (raw_uri.query != nil && raw_uri.query != '')
    adapted.fragment = raw_uri.fragment if (raw_uri.fragment != nil && raw_uri.fragment != '')

    adapted
  end

  private

  def canonical_port
    if port.nil? or
       port == 0 or
         ((scheme == 'http' && port == 80) or (scheme == 'https' && port == 443))
      ''
    else
      ':' + port.to_s
    end
  end
end
