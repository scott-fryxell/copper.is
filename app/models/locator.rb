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
