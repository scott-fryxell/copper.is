class Locator < ActiveRecord::Base
  belongs_to :page
  belongs_to :site

  has_many :tips

  validates_presence_of :page
  validates_associated :page
  validates_presence_of :site
  validates_associated :site
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

  def self.find_or_init_by_url(url_string)
    candidate = parse(url_string)
    if candidate
      existing = find(:first,
                      :conditions => { :scheme   => candidate.scheme,
                                       :site_id  => candidate.site.id,
                                       :userinfo => candidate.userinfo,
                                       :port     => candidate.port,
                                       :path     => candidate.path,
                                       :query    => candidate.query,
                                       :fragment => candidate.fragment }
                      )
      if existing
        existing
      else
        candidate
      end
    end
  end

  def self.parse(url_string)
    case
    # Host name, no path, no scheme
    when url_string.match(/^[a-z0-9\-\.]+\.[a-z0-9]{2,3}\/?$/i)
      url_string = url_string.sub("/","") # remove trailing / character
      adapted = Locator.new
      adapted.scheme = 'http'
      adapted.site = Site.find_or_initialize_by_fqdn(url_string)
      adapted.port = '80'
    # Host name, path, no scheme
    when url_string.match(/^[a-z0-9\-\.]+\/.+$/i)
      adapted = parse_helper('http://' + url_string)
    else
      adapted = parse_helper(url_string)
    end

    if adapted && adapted.scheme && adapted.site
      adapted
    else
      nil
    end
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

  def self.parse_helper(url_string)
    begin
      raw_uri = URI.parse(url_string)

      if raw_uri.host && raw_uri.host.match(/^[a-z0-9\-\.]+\.[a-z0-9\/]{2,3}$/i)
        adapted = Locator.new
        adapted.scheme   = raw_uri.scheme
        adapted.site     = Site.find_or_initialize_by_fqdn(raw_uri.host)
        adapted.userinfo = raw_uri.userinfo if (raw_uri.userinfo != nil && raw_uri.userinfo != '')
        adapted.port     = raw_uri.port     if (raw_uri.port != nil && raw_uri.port != '')
        adapted.path     = raw_uri.path     if (raw_uri.path != nil && raw_uri.path != '' && raw_uri.path != '/')
        adapted.query    = raw_uri.query    if (raw_uri.query != nil && raw_uri.query != '')
        adapted.fragment = raw_uri.fragment if (raw_uri.fragment != nil && raw_uri.fragment != '')

        adapted
      else
        nil
      end
    rescue URI::InvalidURIError
      nil
    end
  end

end