class Authorizer::Vimeo < Author

  include Enqueueable
  include Message::Desirable::Vimeo

  def self.identity_from_url url
    video_id  = URI.parse(url).path.split('/')[1]
    # user_name = Vimeo::Simple::Video.info(video_id)[0]['user_name']
    video_info  = Vimeo::Simple::Video.info(video_id)[0]
    user_id   = video_info['user_id']
    user_name = URI.parse(video_info['user_url']).path().split('/').last


    puts " ************** #{user_name} ***********"

    { provider:'vimeo', username:user_name, uid:user_id }
  end

  def self.filter_url url
    url = Author.parse_url url

    if %r{/groups/|/share/}.match(url.path)
      nil
    else
      'vimeo'
    end
  end

end
