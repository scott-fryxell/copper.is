class Authorizer::Tumblr < Author

  include Enqueueable
  include Message::Desirable::Tumblr

  def self.identity_from_url url
    uri = URI.parse(url)
    if %r{/follow/}.match(uri.path)
      username = %r{/follow/}.match(uri.path).post_match
    else
      username = %r{.tumblr.com}.match(uri.host).pre_match
    end
    {provider:'tumblr', uid:username, username: username}
  end

  def self.filter_url  url
    url = Author.parse_url url
    if %r{www.tumblr.com}.match(url.host) and url.path.size < 3
      nil
    elsif %r{/dashboard|/customize|/post|/liked/|/share}.match(url.path)
      nil
    else
      'tumblr'
    end
  end

  def url
    "#{self.uid}.#{self.provider}.com"
  end

end
