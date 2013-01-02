class Identities::Tumblr < Identity

  def self.discover_uid_and_username_from_url url
    uri = URI.parse(url)
    if %r{/follow/}.match(uri.path)
      username = %r{/follow/}.match(uri.path).post_match
    else
      username = %r{.tumblr.com}.match(uri.host).pre_match
    end
    { :uid => username, :username => username}
  end
end
