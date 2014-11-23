class Authors::Youtube < Author
  include Enqueueable
  include Artist::Desirable::Youtube

  def self.identity_from_url url

    path = URI.parse(url).path

    identity = {provider:'youtube'}

    if %r{/watch}.match(path)
      video = ask_youtube.video_by(url)
      identity[:username] = URI.parse(video.author.uri).path.split('/')[2]

    elsif %r{/user/}.match(path)
      identity[:username] = %r{/user/}.match(path).post_match

    elsif user = %r{/}.match(path).post_match
      identity[:username] = user
    end

    unless identity[:username]
      return nil
    end

    identity
  end

private

  def self.ask_youtube
    @client ||= YouTubeIt::Client.new(dev_key:Copper::Application.config.google_code_developer_key)
    # YouTubeIt::OAuth2Client.new(client_access_token: "access_token", client_refresh_token: "refresh_token", client_id: "client_id", client_secret: "client_secret", dev_key: "dev_key", expires_at: "expiration time")
  end

end
