class Authorizer::Github < Author

  include Enqueueable
  include Message::Desirable::Github

  def self.identity_from_url url
    username = URI.parse(url).path.split('/')[1]
    {username:username, provider:'github' }
  end

  def self.filter_url url
    url = Author.parse_url url
    if %r{gist.github.com}.match(url.host)
      nil
    elsif %r{/blog}.match(url.path)
      nil
    else
      'github'
    end
  end

end
