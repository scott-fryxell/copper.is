class Identities::Vimeo < Identity
  def self.discover_uid_and_username_from_url url
    video_id  = URI.parse(url).path.split('/')[1]
    user_name = Vimeo::Simple::Video.info(video_id)[0]['user_name']
    user_id   = Vimeo::Simple::Video.info(video_id)[0]['user_id']
    { uid:user_id, username:user_name }
  end

end
