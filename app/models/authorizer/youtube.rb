class Authorizer::Youtube < Author

  include Enqueueable

  include Message::Desirable::Youtube

  def self.identity_from_url url
    url = Author.parse_url url

    identity = {provider:'youtube'}

    if %r{/watch|/embed}.match(url.path)
      return nil
    elsif %r{/user/}.match(url.path)
      identity[:username] = %r{/user/}.match(url.path).post_match
    else
      identity[:username] = %r{/}.match(url.path).post_match
    end
    identity
  end

private

  def self.ask_youtube
    # @client ||= YouTubeIt::Client.new(dev_key:Copper::Application.config.google_code_developer_key)
    # @client ||= YouTubeIt::OAuth2Client.new(client_access_token: "access_token", client_refresh_token: "refresh_token", client_id: "client_id", client_secret: "client_secret", dev_key: "dev_key", expires_at: "expiration time")
  end

end
