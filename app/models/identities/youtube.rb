class Identities::Youtube < Identity
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

  # def discover_youtube_uid
  #     if self.url =~ /\/user\//
  #       [
  #        'youtube',
  #         URI.parse(self.url).path.split('/').last
  #        ]
  #     else
  #       @client ||= YouTubeIt::Client.new(:dev_key => Copper::Application.config.google_code_dev_key)
  #       video_id = URI.parse(self.url).query.split('&').find{|e| e =~ /^v/}.split('=').last
  #       [
  #        'youtube',
  #         @client.video_by(video_id).author.name
  #        ]
  #     end
  #   end
  #
end
