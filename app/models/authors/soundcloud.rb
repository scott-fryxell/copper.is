class Authors::Soundcloud < Author
  include Enqueueable
  include Artist::Desirable::Soundcloud

  def self.identity_from_url url
    username = URI.parse(url).path.split('/')[1]
    {provider:'soundcloud', username:username }
  end

  def self.filter_url url
    url = Author.parse_url url
    if  %r{/dashboard}.match(url.path)
      nil
    else
      'soundcloud'
    end
  end

end
