class Identities::Youtube < Identity
  include Enqueueable
  include YoutubeMessages

  def self.discover_uid_and_username_from_url url
    path = URI.parse(url).path
    
    if %r{/watch}.match(path) 
      discover_uid_and_username_from_video url
    elsif %r{/user/}.match(path)
      user = %r{/user/}.match(path).post_match
      { :username => user }  
    elsif user = %r{/}.match(path).post_match
      { :username => user }  
    else 
      raise "unable to find a user for this url"
    end
  end
  
  private

  def self.discover_uid_and_username_from_video url
    video = connect_to_api.video_by(url)
    author_id = URI.parse(video.author.uri).path.split('/')[4]
    { :uid => author_id, :username => video.author.name }
  end

  def self.connect_to_api
    YouTubeIt::Client.new(dev_key:Copper::Application.config.google_code_developer_key)
    # YouTubeIt::OAuth2Client.new(client_access_token: "access_token", client_refresh_token: "refresh_token", client_id: "client_id", client_secret: "client_secret", dev_key: "dev_key", expires_at: "expiration time")
  end

  def youtube_it_client
    @client ||= Identity.connect_to_api
  end

  def author_uri
    youtube_it_client.video_by(@video_id).author.uri
  end

  def author_name
    youtube_it_client.video_by(@video_id).author.name
  end

  def channel_uri
    doc = Nokogiri::Document.new(open(author_uri))
    doc.css('link').find do |e|
      e.attr('href') =~ %r{http://www.youtube.com/channel/}
    end.attr('href')
  end

  def channel_id

  end

  def comment(message)
    @comment = Net::HTTP::Post.new(
      "gdata.youtube.com/feeds/api/channels/#{channel_id}/comments",
      'X-GData-Key'=>"key=#{Copper::Application.config.google_code_developer_key}",
      'GData-Version' => 2,
      'Content-Type' => 'application/atom+xml',
      'Authorization' => "Bearer #{access_token}")
    @comment.body = comment_content_template(message)
    @comment
  end

  def comment_content_template(message)
<<POST
<?xml version="1.0" encoding="UTF-8"?>
<entry xmlns="http://www.w3.org/2005/Atom"
    xmlns:yt="http://gdata.youtube.com/schemas/2007">
  <content>#{message}</content>
</entry>
POST
  end

end
