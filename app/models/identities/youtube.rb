class Identities::Youtube < Identity
  include Enqueueable
  include YoutubeMessages
  
  def self.discover_uid_and_username_from_url url
  end

  def discover_uid_and_username_from_url
  end

  def inform_non_user_of_promised_tips
    super do

    end
  end

  def populate_uid_from_username!
    super do
    end
  end

  def populate_username_from_uid!
    super do
    end
  end
  
  private
  
  def youtube_it_client
    @client ||= YouTubeIt::Client.new(:dev_key =>
                  Copper::Application.config.google_code_developer_key)
  end
  
  def author_uri
    youtube_it_client.video_by("9Z8Z9bGBe_M").author.uri
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
