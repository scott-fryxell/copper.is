class Authors::Vimeo < Author
  include Enqueueable
  include Artist::Desirable::Vimeo

  def self.identity_from_url url
    video_id  = URI.parse(url).path.split('/')[1]
    # user_name = Vimeo::Simple::Video.info(video_id)[0]['user_name']
    user_id   = Vimeo::Simple::Video.info(video_id)[0]['user_id']
    { provider:'vimeo', uid:user_id }
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
