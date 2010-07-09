class Locator < ActiveRecord::Base
  has_many :tips
  
  validates_presence_of :host
  validates_presence_of :scheme
  
  validates_format_of :host, :with => /^[a-z0-9\-\.]+$/i
  
  def canonicalized
    canonical = scheme + '://'
    canonical << userinfo + '@' if userinfo
    canonical << host
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
    adapted.host     = raw_uri.host
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
